#!/bin/bash

_APP_NAME=DeepTags
_PKG_DIR=$(readlink -f $(dirname $0))
_ROOT=$(readlink -f $_PKG_DIR/..)
_APP_BIN=$_ROOT/build/release/$_APP_NAME
_RC_DIR=$_PKG_DIR/resources
_DESKTOP_FILE=$_RC_DIR/$_APP_NAME.desktop
_ICON_FILE=$_ROOT/$_APP_NAME.png
_ICON_DIR=$_RC_DIR/icons
_TRANSLATIONS=$_ROOT/locale/*.qm
_APP_VERSION=$($_APP_BIN --version)

_APP_VERSION=0.4.2      # for test purposes

echo "creating the PKGBUILD file"
cat > $_PKG_DIR/PKGBUILD <<EOL
# Maintainer: Zineddine SAIBI <saibi.zineddine@yahoo.com>
pkgname=$_APP_NAME
pkgver=$_APP_VERSION
pkgrel=1
pkgdesc="A Markdown notes manager"
arch=('x86_64')
url="https://github.com/SZinedine/DeepTags"
license=('GPL')
depends=('qt5-base>=5.6')
makedepends=('git' 'wget' 'gcc' 'make')
source=("$pkgname::git+https://github.com/SZinedine/DeepTags.git#tag=$pkgver")
md5sums=('SKIP')
install=DeepTags.install

build() {
    cd "\$pkgname"
    qmake
    make
}

package() {
    mkdir -p "\$pkgdir/opt/\$pkgname"
    install -Dm 644 "\$pkgname/\$pkgname.desktop" "\${pkgdir}/usr/share/applications/\$pkgname.desktop"
    install -Dm 644 "\$pkgname/\$pkgname.png" "\$pkgdir/usr/share/icons/hicolor/\$pkgname.png"
    install -Dm 644 "\$pkgname/\$pkgname.png" "\$pkgdir/usr/share/icons/hicolor/256x256/apps/\$pkgname.png"
    cd "\$pkgname"
    echo "installing... \$pkgdir"
    make INSTALL_ROOT="\$pkgdir" install
}
EOL


echo "creating the .install file"
cat > $_PKG_DIR/DeepTags.install <<EOL
post_install() {
    ln -s /opt/DeepTags/bin/DeepTags /usr/bin/DeepTags
} 

post_remove() {
	rm -f /usr/bin/DeepTags
}
EOL


exit 0
rm -f DeepTags.install PKGBUILD

