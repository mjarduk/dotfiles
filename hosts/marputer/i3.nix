{ pkgs, ... }:
let
  i3status-peak-wrapper = pkgs.writeShellApplication {
    name = "i3status-peak-wrapper";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      # DeepSeek peak hours: 01:00-04:00 and 06:00-10:00 UTC, Mon-Fri.

      peak_block() {
        local now today dow hour label color
        local offset d datestr th cand next_epoch left h m s

        now=$(date -u +%s)
        today=$(date -u -d "@$now" +%Y-%m-%d)
        dow=$(date -u -d "@$now" +%u)
        hour=$((10#$(date -u -d "@$now" +%H)))

        if (( dow >= 1 && dow <= 5 )) && { (( hour >= 1 && hour < 4 )) || (( hour >= 6 && hour < 10 )); }; then
          label="PEAK"
          color="#eb6f92"
        else
          label="OFF-PEAK"
          color="#3e8fb0"
        fi

        # Find the next transition instant (weekday, 01:00/04:00/06:00/10:00 UTC).
        # A 4-day search window covers the widest gap: Fri 10:00 -> Mon 01:00.
        next_epoch=""
        for offset in 0 1 2 3; do
          read -r d datestr <<< "$(date -u -d "$today +$offset day" +'%u %Y-%m-%d')"
          (( d < 1 || d > 5 )) && continue
          for th in 01 04 06 10; do
            cand=$(date -u -d "$datestr ''${th}:00:00" +%s)
            if (( cand > now )) && { [[ -z $next_epoch ]] || (( cand < next_epoch )); }; then
              next_epoch=$cand
            fi
          done
        done

        left=$(( next_epoch - now ))
        h=$(( left / 3600 ))
        m=$(( (left % 3600) / 60 ))
        s=$(( left % 60 ))

        printf '{"full_text":"🐬 %s (%d:%02d:%02d left)","color":"%s"}' "$label" "$h" "$m" "$s" "$color"
      }

      read -r header
      printf '%s\n' "$header"
      read -r opening
      printf '%s\n' "$opening"

      while IFS= read -r line; do
        prefix=""
        json=$line
        if [[ $line == ,* ]]; then
          prefix=","
          json=''${line:1}
        fi
        block=$(peak_block)
        printf '%s%s\n' "$prefix" "$(jq -c --argjson b "$block" '[$b] + .' <<< "$json")"
      done
    '';
  };
in {
  xdg.configFile."i3/config".source = ./i3/config;
  xdg.configFile."i3status/config".source = ./i3/config_status;
  home.packages = [ i3status-peak-wrapper ];
}
