# 01.GNU_Linux
Repositorios relacionados con GNU/Linux. Este repositorio esta en constante mutacion.

Este repositorio esta contruido con muestras, no se recomienda su uso a menos que sepas exactamente que estas haciendo.

### Scripts
Scripts para controlar el sistema, estan divididos en:

    - Xperiment, Scripts experimentales, generalmente funcionales
    - Media.hs, Scripts para controlar medios multimedia
    - System.sh, Scripts para el control del sistema
    - User.sh, Scripts para cosas sencillas que quiera hacer el usuario
    - Work.sh, Scripts para acciones de alto consumo de recursos

#### Uso de los scripts
Estos scripts estan hecho para poder ser usados mediante alias y keybinds.

alias:

    - alias spk="~/.config/scripts/User.sh textToAudio español $3"
        - $3 es un arvhico .txt que quieras comvertir a audio

keybinds

    - ((myUiuxKey, xK_F12   ), spawn "~/.config/scripts/Media.sh videoPlayer volumeUp")
        - myUiuxKey depende de tu gestor de ventanas o tu gestor de layout y/o keys
        - puedes usar cualquier metodo capas de usar spawn/lanzar procesos
