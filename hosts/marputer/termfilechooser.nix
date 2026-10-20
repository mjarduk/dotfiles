{ ... }: {
  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=$HOME/.config/xdg-desktop-portal-termfilechooser/ranger-wrapper.sh
    default_dir=$HOME
    env=PATH="$PATH:/run/current-system/sw/bin"
    open_mode=suggested
    save_mode=last
  '';

  xdg.configFile."xdg-desktop-portal-termfilechooser/ranger-wrapper.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      multiple="$1"
      directory="$2"
      save="$3"
      path="$4"
      out="$5"
      debug="$6"

      set -e
      if [ "$debug" = 1 ]; then
          set -x
      fi

      cmd="ranger"
      termcmd="''${TERMCMD:-alacritty -T 'termfilechooser' -e}"

      if [ "$save" = "1" ]; then
          set -- --choosefile="$out" --cmd="echo Select save path (see tutorial in preview pane; try pressing zv or zp if no preview)" --selectfile="$path"
      elif [ "$directory" = "1" ]; then
          set -- --choosedir="$out" --show-only-dirs --cmd="echo Select directory (quit in dir to select it)" "$path"
      elif [ "$multiple" = "1" ]; then
          set -- --choosefiles="$out" --cmd="echo Select file(s) (open file to select it; <Space> to select multiple)" "$path"
      else
          set -- --choosefile="$out" --cmd="echo Select file (open file to select it)" "$path"
      fi

      command="$termcmd $cmd"
      for arg in "$@"; do
          escaped=$(printf "%s" "$arg" | sed 's/"/\\"/g')
          command="$command \"$escaped\""
      done

      sh -c "$command"
    '';
  };
}
