# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit flag-o-matic python-any-r1 eutils

DESCRIPTION="A hackable text editor for the 21st Century"
HOMEPAGE="https://atom.io"
SRC_URI="https://github.com/atom/atom/archive/v${PV}.tar.gz -> ${PV}.tar.gz"
RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	net-libs/nodejs[npm]
	media-fonts/inconsolata
	gnome-base/gconf
	x11-libs/gtk+:2
	gnome-base/libgnome-keyring
	x11-libs/libnotify
	x11-libs/libXtst
	dev-libs/nss
	media-libs/alsa-lib
"
RDEPEND="${DEPEND}"

pkg_setup() {
	python-any-r1_pkg_setup
	npm config set python $PYTHON
}

src_prepare(){
	epatch "${FILESDIR}/${PN}-python.patch"
	sed -i  -e "/exception-reporting/d" \
		-e "/metrics/d" package.json
	sed -e "s/<%= description %>/$pkgdesc/" \
		-e "s|<%= installDir %>/share/<%= appFileName %>/atom|/usr/bin/atom|"\
		-e "s|<%= iconPath %>|atom|"\
		-e "s|<%= appName %>|Atom|" \
		resources/linux/atom.desktop.in > resources/linux/Atom.desktop

	# Fix atom location guessing
	sed -i -e 's/ATOM_PATH="$USR_DIRECTORY\/share\/atom/ATOM_PATH="$USR_DIRECTORY\/../g' \
		./atom.sh \
		|| die "Fail fixing atom-shell directory"

	# Make bootstrap process more verbose
	sed -i -e 's@node script/bootstrap@node script/bootstrap --no-quiet@g' \
		./script/build \
		|| die "Fail fixing verbosity of script/build"
	default
}

src_compile(){
	./script/build --verbose --build-dir "${T}" || die "Failed to compile"
	"${T}/Atom/resources/app/apm/bin/apm" rebuild || die "Failed to rebuild native module"
	echo "python = $PYTHON" >> "${T}/Atom/resources/app/apm/.apmrc"
}

src_install(){
	insinto "/usr/share/${PN}"
	doins -r "${T}"/Atom/*
	insinto "/usr/share/applications"
	newins resources/linux/Atom.desktop atom.desktop
	insinto "/usr/share/pixmaps"
	newins resources/app-icons/stable/png/128.png atom.png
	insinto "/usr/share/licenses/${PN}"
	doins LICENSE.md
	# Fixes permissions
	fperms +x "/usr/share/${PN}/${PN}"
	fperms +x "/usr/share/${PN}/libgcrypt.so.11"
	fperms +x "/usr/share/${PN}/resources/app/atom.sh"
	fperms +x "/usr/share/${PN}/resources/app/apm/bin/apm"
	fperms +x "/usr/share/${PN}/resources/app/apm/bin/node"
	fperms +x "/usr/share/${PN}/resources/app/apm/node_modules/npm/bin/node-gyp-bin/node-gyp"
	# Symlinking to /usr/bin
	dosym "/usr/share/${PN}/resources/app/atom.sh" /usr/bin/atom
	dosym "/usr/share/${PN}/resources/app/apm/bin/apm" /usr/bin/apm
}
