# 01.GNU_Linux
Repositorios relacionados con GNU/Linux. Este repositorio esta en constante mutacion.

Este repositorio esta construido con muestras, no se recomienda su uso a menos que sepas exactamente que estas haciendo.
En caso de uso lee primero el archivo a usar y perzonalizalo a tus circunstancias, existen partes creadas con ese objetivo, por lo que si no se personaliza es muy posible que no funcione.


### Scripts
Scripts para controlar el sistema, estan divididos en:

    - Xperiment, Scripts experimentales, generalmente funcionales
    - Media.hs, Scripts para controlar medios multimedia
    - System.sh, Scripts para el control del sistema
    - User.sh, Scripts para cosas sencillas que quiera hacer el usuario
    - Work.sh, Scripts para acciones de alto consumo de recursos

#### Uso de los scripts
Estos scripts estan hechos para poder ser usados mediante alias y keybinds.

alias:

    - alias spk="~/.config/scripts/User.sh textToAudio español $3"
        - $3 es un archivo .txt que quieras convertir a audio

keybinds

    - ((myUiuxKey, xK_F12   ), spawn "~/.config/scripts/Media.sh videoPlayer volumeUp")
        - myUiuxKey depende de tu gestor de ventanas o tu gestor de layout y/o keys
        - puedes usar cualquier metodo capas de usar spawn/lanzar procesos

### InstallSystemScripts
Scripts para poder instalar su respectiva distribucion GNU/Linux.

No se recomienda su uso a menos que sepas exactamente que estas haciendo, puedes tener perdidas de datos en tu configuracion de sistema, se recomienda probar con maquinas virtuales, especialmente qemu vanilla y cuya configuracion puedes encontrar en este repositorio "./scripts/Work.sh".

Es altamente recomendado leer primero el script y personalizarlo, de lo contrario puede no funcionar, para facilitar el agregar y quitar configuraciones el script esta modularizado y por dentro todo esta ordenado en funciones.

#### Uso de los scripts
Estos scripts estan hechos para poder instalar archlinux y gentoo, respectivamente, solo hay que clonar el repositorio, leer, mover al home del live el dirtectorio de los scripts y ejecutar.

Archlinux, basado en la documentacion de archlinux, con claras modificaciones.
https://wiki.archlinux.org/title/Installation_guide

    - $ ./base.sh
        - correr ./base.sh para installar archlinux

Gentoo, basado en el handbook de gentoo, con muy pocas modificaciones.
https://wiki.gentoo.org/wiki/Handbook:AMD64

    - $ ./install.sh
        - correr ./install.sh para installar archlinux
