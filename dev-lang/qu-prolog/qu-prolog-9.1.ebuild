# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils multilib qmake-utils

MY_P=qp${PV}

DESCRIPTION="Extended Prolog supporting quantifiers, object-variables and substitutions"
HOMEPAGE="http://www.itee.uq.edu.au/~pjr/HomePages/QuPrologHome.html"
SRC_URI="http://www.itee.uq.edu.au/~pjr/HomePages/QPFiles/${MY_P}.tar.gz"

LICENSE="Qu-Prolog GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug doc examples pedro qt4 readline threads"

RDEPEND="
	!dev-util/mpatch
	!dev-util/rej
	qt4? ( dev-qt/qtgui:4 )
	pedro? ( net-misc/pedro )
	readline? ( app-misc/rlwrap )"

DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-portage.patch \
		"${FILESDIR}"/${P}-cflags.patch \
		"${FILESDIR}"/${P}-cerr-ptr.patch \
		"${FILESDIR}"/${P}-gcc.patch
}

src_configure() {
	econf \
		--libdir=/usr/$(get_libdir) \
		$(use_enable debug) \
		$(use_enable threads multiple-threads)

	if use qt4; then
		cd "${S}"/src/xqp || die
		eqmake4 xqp.pro
	fi
}

src_compile() {
	emake || die "emake failed"

	if use qt4; then
		cd "${S}"/src/xqp || die
		emake || die "emake xqp failed"
	fi
}

src_install() {
	sed -i -e "s|${S}|/usr/$(get_libdir)/qu-prolog|g" \
		bin/qc bin/qc1.qup bin/qecat bin/qg bin/qp || die

	dobin bin/qa bin/qdeal bin/qem bin/ql || die
	dobin bin/qc bin/qc1.qup bin/qecat bin/qg bin/qp bin/qppp || die
	dobin bin/kq || die

	if use qt4; then
		dobin src/xqp/xqp || die
	fi

	insinto /usr/$(get_libdir)/${PN}/bin
	doins bin/rl_commands
	doins bin/qc1.qup.qx \
		bin/qecat.qx \
		bin/qg.qx \
		bin/qp.qx || die

	insinto /usr/$(get_libdir)/${PN}/library
	doins prolog/library/*.qo || die

	insinto /usr/$(get_libdir)/${PN}/compiler
	doins prolog/compiler/*.qo || die

	doman doc/man/man1/*.1 || die

	dodoc README || die

	if use doc ; then
		docinto reference-manual
		dodoc doc/manual/*.html || die
		docinto user-guide
		dodoc doc/user/main.pdf || die
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.ql || die
		docinto examples
		dodoc examples/README || die
	fi
}
