# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib qmake-utils

MY_P=qp${PV}

DESCRIPTION="Extended Prolog supporting quantifiers, object-variables and substitutions"
HOMEPAGE="http://www.itee.uq.edu.au/~pjr/HomePages/QuPrologHome.html"
SRC_URI="http://www.itee.uq.edu.au/~pjr/HomePages/QPFiles/${MY_P}.tar.gz"

LICENSE="Apache-2.0 GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="debug doc examples pedro qt5 readline threads"

RDEPEND="
	!dev-util/mpatch
	!dev-util/rej
	!games-rpg/kqlives
	qt5? (
		dev-qt/qtwidgets:5
		dev-qt/qtgui:5
	 )
	pedro? ( net-misc/pedro )
	readline? ( app-misc/rlwrap )"
DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure.patch
	epatch "${FILESDIR}"/${P}-associated-item.patch
	epatch "${FILESDIR}"/${P}-gcc6.patch
	epatch "${FILESDIR}"/${P}-qt5.patch
}

src_configure() {
	econf \
		--libdir=/usr/$(get_libdir) \
		$(use_enable debug) \
		$(use_enable threads multiple-threads)

	if use qt5; then
		cd "${S}"/src/xqp || die
		eqmake5 xqp.pro
	fi
}

src_compile() {
	emake OPTIMISATION="${CXXFLAGS}"

	if use qt5; then
		cd "${S}"/src/xqp || die
		emake
	fi
}

src_install() {
	sed \
		-e "s|${S}|/usr/$(get_libdir)/qu-prolog|g" \
		-i bin/qc bin/qc1.qup bin/qecat bin/qg bin/qp || die

	dobin bin/{qc,qecat,qp,kq}

	use qt5 && dobin src/xqp/xqp

	into /usr/$(get_libdir)/${PN}
	dobin bin/{qa,qc1.qup,qdeal,qem,qg,ql,qppp}

	insinto /usr/$(get_libdir)/${PN}/bin
	doins bin/rl_commands
	doins bin/{qc1.qup,qecat,qg,qp}.qx

	insinto /usr/$(get_libdir)/${PN}/library
	doins prolog/library/*.qo

	insinto /usr/$(get_libdir)/${PN}/compiler
	doins prolog/compiler/*.qo

	doman doc/man/man1/*.1

	dodoc README

	if use doc ; then
		docinto reference-manual
		dodoc doc/manual/*.html
		docinto user-guide
		dodoc doc/user/main.pdf
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.ql
		docinto examples
		newdoc examples/README README.examples
	fi
}
