# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_4 python3_5 python3_6 )

inherit python-single-r1 xdg

DESCRIPTION="A curses-based client for Tox."
HOMEPAGE="https://github.com/JFreegman/toxic"
SRC_URI="https://github.com/JFreegman/toxic/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+X +audio notifications +python +qrcode +video"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Not a typo; net-libs/tox only has a 'both or neither' option
RDEPEND="
	|| (
	audio? ( net-libs/tox:0/0.1[av] )
	video? ( net-libs/tox:0/0.1[av] )
	net-libs/tox:0/0.1
	)
	dev-libs/libconfig
	net-misc/curl:0=
	sys-libs/ncurses:0=
	audio? ( media-libs/openal media-libs/freealut )
	video? ( media-libs/libvpx:= x11-libs/libX11 )
	notifications? ( x11-libs/libnotify )
	python? ( ${PYTHON_DEPS} )
	qrcode? ( media-gfx/qrencode )
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/${P}-verbose-build-log.patch"
	)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	# bug 630370: version string correction 0.7.2 -> 0.8.0
	# REMOVE THIS FOR toxic != 0.8.0
	sed -i \
		-e 's/^\(TOXIC_VERSION =\).*$/\1 0.8.0/' \
		cfg/global_vars.mk || die "Version string correction failed."
}

src_configure() {
	export USER_CFLAGS="${CFLAGS}"
	export USER_LDFLAGS="${LDFLAGS}"
	if ! use video && ! use audio; then
		export DISABLE_AV=1
	fi
	if ! use audio; then
		export DISABLE_SOUND_NOTIFY=1
	fi
	if ! use X; then
		export DISABLE_X11=1
	fi
	if ! use notifications; then
		export DISABLE_DESKTOP_NOTIFY=1
	fi
	if ! use qrcode; then
		export DISABLE_QRPNG=1
	fi
	if use python; then
		export ENABLE_PYTHON=1
	fi
	sed -i \
		-e "s,/usr/local,${EPREFIX}/usr,g" \
		cfg/global_vars.mk || die "PREFIX sed failed"
}

src_compile() {
	emake V=1 || die "emake failed"
}

src_install() {
	default
	if ! use audio; then
		rm -r "${ED%/}"/usr/share/${PN}/sounds || die "Could not remove sounds directory"
	fi
}
