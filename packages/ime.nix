{
  pkgs,
  ...
}:
{

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;

    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk # alternatively, kdePackages.fcitx5-qt
        qt6Packages.fcitx5-chinese-addons # table input method support
        fcitx5-nord # a color theme
      ];

      settings = {
        globalOptions = {
          "Hotkey/TriggerKeys" = {
            "0" = "Tools";
          };

          "Hotkey/EnumerateForwardKeys" = {
            "0" = "Tools";
          };

          "Hotkey" = {
            "EnumerateWithTriggerKeys" = "False";
            "EnumerateSkipFirst" = "False";
          };
        };

        inputMethod = {
          GroupOrder = {
            "0" = "Default";
          };

          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "pinyin";
          };

          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };

          "Groups/0/Items/1" = {
            Name = "pinyin";
            Layout = "";
          };
        };

        addons.pinyin = {
          globalSection = {
            ShuangpinProfile = "Ziranma";
            ShowShuangpinMode = "True";
            PageSize = "7";
            SpellEnabled = "True";
            SymbolsEnabled = "True";
            ChaiziEnabled = "True";
            ExtBEnabled = "True";
            StrokeCandidateEnabled = "True";
            CloudPinyinEnabled = "False";
            CloudPinyinIndex = "2";
            CloudPinyinAnimation = "True";
            KeepCloudPinyinPlaceHolder = "False";
            PreeditMode = "Composing pinyin";
            PreeditCursorPositionAtBeginning = "True";
            PinyinInPreedit = "False";
            Prediction = "False";
            PredictionSize = "49";
            BackspaceBehaviorOnPrediction = "Backspace when not using on-screen keyboard";
            SwitchInputMethodBehavior = "Commit current preedit";
            UseKeypadAsSelection = "False";
            BackSpaceToUnselect = "True";
            "Number of sentence" = "2";
            WordCandidateLimit = "15";
            LongWordLengthLimit = "4";
            QuickPhraseKey = "semicolon";
            VAsQuickphrase = "True";
            FirstRun = "False";
          };

          sections = {
            ForgetWord."0" = "Control+7";

            PrevPage = {
              "0" = "minus";
              "1" = "Up";
              "2" = "KP_Up";
              "3" = "Page_Up";
            };

            NextPage = {
              "0" = "equal";
              "1" = "Down";
              "2" = "KP_Down";
              "3" = "Next";
            };

            PrevCandidate."0" = "Shift+Tab";
            NextCandidate."0" = "Tab";

            CurrentCandidate = {
              "0" = "space";
              "1" = "KP_Space";
            };

            CommitRawInput = {
              "0" = "Return";
              "1" = "KP_Enter";
              "2" = "Control+Return";
              "3" = "Control+KP_Enter";
              "4" = "Shift+Return";
              "5" = "Shift+KP_Enter";
              "6" = "Control+Shift+Return";
              "7" = "Control+Shift+KP_Enter";
            };

            ChooseCharFromPhrase = {
              "0" = "bracketleft";
              "1" = "bracketright";
            };

            FilterByStroke."0" = "grave";

            QuickPhraseTriggerRegex = {
              "0" = ".(/|@)$";
              "1" = "^(www|bbs|forum|mail|bbs)\\\\.";
              "2" = "^(http|https|ftp|telnet|mailto):";
            };

            Fuzzy = {
              VE_UE = "True";
              NG_GN = "True";
              Inner = "True";
              InnerShort = "True";
              PartialFinal = "True";
              PartialSp = "False";
              V_U = "True";
              AN_ANG = "True";
              EN_ENG = "True";
              IAN_IANG = "True";
              IN_ING = "True";
              U_OU = "False";
              UAN_UANG = "False";
              C_CH = "False";
              F_H = "False";
              L_N = "False";
              L_R = "False";
              S_SH = "False";
              Z_ZH = "False";
              Correction = "None";
            };
          };
        };
      };

      # Optional, but recommended if ~/.config/fcitx5/config is overriding this.
      ignoreUserConfig = true;
    };
  };
}
