# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit python-single-r1 xdg

DESCRIPTION="A curses-based client for Tox"
HOMEPAGE="https://github.com/JFreegman/toxic"
SRC_URI="https://github.com/JFreegman/toxic/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/fx-carton/toxic_patches/archive/v${PV}.tar.gz -> ${PN}_patches-${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+X +sound notification +python +qrcode +video"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Not a typo; net-libs/tox only has a 'both or neither' option
RDEPEND="
	net-libs/tox:0/0.2
	dev-libs/libconfig
	net-misc/curl:0=
	sys-libs/ncurses:0=
	notification? ( x11-libs/libnotify )
	python? ( ${PYTHON_DEPS} )
	qrcode? ( media-gfx/qrencode:= )
	sound? (
		media-libs/openal
		media-libs/freealut
		net-libs/tox:0/0.2[av]
	)
	video? (
		media-libs/libvpx:=
		net-libs/tox:0/0.2[av]
		x11-libs/libX11
	)
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"

PATCHES=(
	"${WORKDIR}/${PN}_patches-${PV}/${P}-make-qrencode-optional.patch"
	)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	if [[ ${PV} = 0.8.2 ]]; then
		sed -i \
			-e 's/^\(TOXIC_VERSION =\).*$/\1 0.8.2/' \
			cfg/global_vars.mk || die
	else
		die "Remove stale version hack"
	fi
	sed -i '/^VIDEO = /s/DISABLE_AV/DISABLE_VI/g' cfg/checks/check_features.mk || die
	find . '(' -name '*.mk' -o -name 'Makefile' ')' -exec sed -i 's/^\t@/\t/' {} + || die
}

src_configure() {
	export USER_CFLAGS="${CFLAGS}"
	export USER_LDFLAGS="${LDFLAGS}"
	if ! use sound; then
		export DISABLE_AV=1
		export DISABLE_SOUND_NOTIFY=1
	fi
	if ! use video; then
		export DISABLE_VI=1
	fi
	if ! use X; then
		export DISABLE_X11=1
	fi
	if ! use notification; then
		export DISABLE_DESKTOP_NOTIFY=1
	fi
	if ! use qrcode; then
		export DISABLE_QRCODE=1
		export DISABLE_QRPNG=1
	fi
	if use python; then
		export ENABLE_PYTHON=1
	fi
	sed -i \
		-e "s,/usr/local,${EPREFIX}/usr,g" \
		cfg/global_vars.mk || die "PREFIX sed failed"
}

src_install() {
	default
	if ! use sound; then
		rm -r "${ED%/}"/usr/share/${PN}/sounds || die "Could not remove sounds directory"
	fi
}
