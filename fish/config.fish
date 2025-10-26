if status is-interactive

    # fzf change setting
    # set -x FZF_DEFAULT_OPTS '--bind j:down,k:up,q:abort '
    set -x FZF_DEFAULT_OPTS '--bind j:down,k:up,q:abort --border --cycle'

    # important stuff
    # Locale fix for UTF-8 and tools like btop
    set -x LANG en_IN.UTF-8
    set -x LANGUAGE en_IN.UTF-8:en_US.UTF-8
    set -x LC_ALL en_IN.UTF-8

    # Enable Vim keybindings in Fish shell
    fish_vi_key_bindings

    # Map 'jj' in insert mode to escape to normal mode
    function fish_user_key_bindings
        bind -M insert jj 'set fish_bind_mode default; commandline -f repaint'
    end

    # run command tmenu when not in tmux
    if not set -q TMUX
        if type -q tmenu
            ~/.local/bin/topen.sh d home
        end
    end

    # Initialize Starship prompt
    starship init fish | source

    # Run Fastfetch on shell start without logo
    fastfetch --config ~/.config/fastfetch/config2.jsonc --logo-type none
    # cat anime.txt

    # Alias to launch Telegram
    alias telegram="/opt/telegram/Telegram"

    # 👉 Alias to exit shell using :q (like in Vim)
    alias :q="exit"

    alias lh="ls -a"

    alias lvim="NVIM_APPNAME=Lazyvimed nvim"

    alias nvchad="NVIM_APPNAME=nvchad nvim"
end

# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
