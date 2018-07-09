# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1
inherit distutils-r1 eutils

MY_P="SNNSv${PV}"
DESCRIPTION="Stuttgart Neural Network Simulator"
HOMEPAGE="https://sourceforge.net/projects/snns/"
SRC_URI="http://www.ra.cs.uni-tuebingen.de/downloads/SNNS/${MY_P}.tar.gz
	doc? ( http://www.ra.cs.uni-tuebingen.de/downloads/SNNS/SNNSv4.2.Manual.pdf )"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 ppc x86"
SLOT="0"
IUSE="X doc python"

RDEPEND="X? (
		x11-libs/libX11
		x11-libs/libXaw3d
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
	>=sys-devel/bison-1.2.2"

RDEPEND+=" python? ( ${PYTHON_DEPS} )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/4.3-unstrip.patch
	epatch "${FILESDIR}"/4.3-bison-version.patch
	epatch "${FILESDIR}"/4.2-ldflags.patch
	epatch "${FILESDIR}"/4.3-snns-netperf.patch # bug 248322

	# change all references of Xaw to Xaw3d
	cd "${S}"/xgui/sources
	for file in *.c; do
		sed -e "s:X11/Xaw/:X11/Xaw3d/:g" -i "${file}"
	done

	# clean up the dirty dist sources and remove files that apparently
	# are not removed by any clean rules
	emake clean
	rm -Rf "${S}"/{tools,xgui}/bin \
		"${S}"/{Makefile.def,config.h} \
		"${S}"/configuration/config.{guess,log}

	epatch_user

	if use python; then
		pushd "${S}"/python > /dev/null || die
		distutils-r1_src_prepare
		popd > /dev/null || die
	fi
}

src_configure() {
	econf --enable-global \
		$(use_with X x)

	if use python; then
		pushd python > /dev/null || die
		distutils-r1_src_configure
		popd > /dev/null || die
	fi
}

src_compile() {
	local compileopts=( compile-kernel compile-tools )
	use X && compileopts+=( compile-xgui )

	# parallel make sometimes fails (phosphan)
	# so emake each phase separately (axs)
	for tgt in "${compileopts[@]}"; do
		emake ${tgt}
	done

	if use python; then
		pushd python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_install() {
	pushd "${S}"/tools/sources > /dev/null || die
	emake TOOLSBINDIR="${ED}"usr/bin install
	popd > /dev/null || die

	if use X; then
		newbin xgui/sources/xgui snns

		echo XGUILOADPATH=/usr/share/doc/${PF} > "${T}"/99snns
		doenvd "${T}"/99snns

		docompress -x /usr/share/doc/${PF}/{default.cfg,help.hdoc}
		insinto /usr/share/doc/${PF}
		doins default.cfg help.hdoc
	fi

	if use python; then
		pushd python > /dev/null || die
		distutils-r1_src_install
		insinto /usr/share/doc/${PF}/python-examples
		doins examples/*
		newdoc README README.python
		popd > /dev/null || die
	fi

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/SNNSv4.2.Manual.pdf
	fi

	insinto /usr/share/doc/${PF}/examples
	doins examples/*
	doman man/man*/*
}
