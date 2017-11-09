# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_4 python3_5 python3_6 )

inherit python-single-r1

DESCRIPTION="A curses-based client for Tox."
HOMEPAGE="https://github.com/JFreegman/toxic"
SRC_URI="https://github.com/JFreegman/toxic/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+X +av notifications +python +qrcode"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	net-libs/tox:0/0.1[av?]
	dev-libs/libconfig
	net-misc/curl:0=
	sys-libs/ncurses:0=
	av? ( media-libs/openal media-libs/freealut )
	notifications? ( x11-libs/libnotify )
	python? ( ${PYTHON_DEPS} )
	qrcode? ( media-gfx/qrencode )
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"

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
	if ! use av; then
		export DISABLE_AV=1
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

src_install() {
	default
	if ! use av; then
		rm -r "${ED%/}"/usr/share/${PN}/sounds || die "Could not remove sounds directory"
	fi
}
