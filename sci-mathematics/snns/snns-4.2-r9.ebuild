# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/snns/snns-4.2-r9.ebuild,v 1.2 2012/02/26 05:28:38 patrick Exp $

EAPI="3"
PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils eutils

MY_P="SNNSv${PV}"
DESCRIPTION="Stuttgart Neural Network Simulator"
HOMEPAGE="http://sourceforge.net/projects/snns/"
SRC_URI="mirror://sourceforge/snns/${PN}-${PV}-patched.tar.gz
	doc? ( http://www-ra.informatik.uni-tuebingen.de/downloads/SNNS/${MY_P}.Manual.pdf )
	python? ( mirror://sourceforge/snns/python.patch.gz )"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE="X doc python"

RDEPEND="X? ( x11-libs/libXaw3d )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${PN}-${PV}-patched.tar.gz

	if use python; then
		unpack python.patch.gz
	fi
}

src_prepare() {

	if use python; then
		epatch "${WORKDIR}/python.patch"
	fi

	cd xgui/sources
	for file in *.c; do
		sed -e "s:X11/Xaw/:X11/Xaw3d/:g" -i "${file}"
	done
}

src_configure() {
	local myconf="--enable-global"

	if use X; then
		myconf+=" --with-x"
	else
		myconf+=" --without-x"
	fi

	econf ${myconf}
}

src_compile() {
	local compileopts="compile-kernel compile-tools"
	if use X; then
		compileopts+=" compile-xgui"
	fi

	# parallel make sometimes fails (phosphan)
	emake -j1 ${compileopts} || die "make failed"

	if use python; then
		pushd python > /dev/null
		distutils_src_compile
		popd > /dev/null
	fi
}

src_install() {
	for file in `find tools -type f -perm +100`; do
		dobin $file
	done

	mv "${D}/usr/bin/netperf" "${D}/usr/bin/snns-netperf"

	if use X; then
		newbin xgui/sources/xgui snns

		dodir /etc/env.d
		echo XGUILOADPATH=/usr/share/doc/${PF}/ > "${D}"/etc/env.d/99snns

		insinto /usr/share/doc/${PF}
		doins default.cfg help.hdoc
	fi

	if use python; then
		pushd python > /dev/null
		distutils_src_install
		cp -pPR examples "${D}"/usr/share/doc/${PF}/python-examples
		chmod +x "${D}"/usr/share/doc/${PF}/python-examples/*.py
		newdoc README README.python
		popd > /dev/null
	fi

	insinto /usr/share/doc/${PF}
	use doc && doins "${DISTDIR}"/${MY_P}.Manual.pdf

	insinto /usr/share/doc/${PF}/examples
	doins examples/*

	doman man/man*/*
}

pkg_postinst() {
	if use python; then
		distutils_pkg_postinst
	fi
}

pkg_postrm() {
	if use python; then
		distutils_pkg_postrm
	fi
}
