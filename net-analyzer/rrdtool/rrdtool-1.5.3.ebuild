# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/rrdtool/rrdtool-1.5.3.ebuild,v 1.2 2015/05/15 05:47:35 jer Exp $

EAPI="5"

DISTUTILS_OPTIONAL=true
DISTUTILS_SINGLE_IMPL=true
GENTOO_DEPEND_ON_PERL=no
PYTHON_COMPAT=( python2_7 )
inherit autotools eutils perl-module distutils-r1 flag-o-matic multilib

DESCRIPTION="A system to store and display time-series data"
HOMEPAGE="http://oss.oetiker.ch/rrdtool/"
SRC_URI="http://oss.oetiker.ch/rrdtool/pub/${P/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="dbi doc graph lua perl python rrdcgi ruby static-libs tcl tcpd"

CDEPEND="
	>=dev-libs/glib-2.28.7:2[static-libs(+)?]
	>=dev-libs/libxml2-2.7.8:2[static-libs(+)?]
	dbi? ( dev-db/libdbi[static-libs(+)?] )
	graph? (
		>=media-libs/libpng-1.5.10:0=[static-libs(+)?]
		>=x11-libs/cairo-1.10.2[svg,static-libs(+)?]
		>=x11-libs/pango-1.28
	)
	lua? ( dev-lang/lua:*[deprecated] )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	tcl? ( dev-lang/tcl:0= )
	tcpd? ( sys-apps/tcp-wrappers )
"

DEPEND="
	${CDEPEND}
	sys-apps/groff
	virtual/pkgconfig
	virtual/awk
"
RDEPEND="
	${CDEPEND}
"
PDEPEND="
	ruby? ( ~dev-ruby/rrdtool-bindings-${PV} )
"

S=${WORKDIR}/${P/_/-}

python_compile() {
	cd bindings/python || die
	distutils-r1_python_compile
}

python_install() {
	cd bindings/python || die
	distutils-r1_python_install
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.4.7-configure.ac.patch \
		"${FILESDIR}"/${PN}-1.4.9-disable-rrd_graph-cgi.patch \
		"${FILESDIR}"/${PN}-1.4.9-disable-rrd_graph-perl.patch \
		"${FILESDIR}"/${PN}-1.5.0_rc1-disable-rrd_graph-lua.patch \
		"${FILESDIR}"/${PN}-1.5.0_rc1-disable-rrd_graph-python.patch

	# bug 456810
	# no time to sleep
	sed -i \
		-e 's|$LUA_CFLAGS|IGNORE_THIS_BAD_TEST|g' \
		-e 's|^sleep 1$||g' \
		-e '/^dnl.*png/s|^dnl||g' \
		configure.ac || die

	# Python bindings are built/installed manually
	sed -i \
		-e '/^all-local:/s| @COMP_PYTHON@||' \
		bindings/Makefile.am || die

	echo ${PV/_rc*/} >> VERSION || die

	export rd_cv_gcc_flag__Werror=no

	eautoreconf
}

src_configure() {
	filter-flags -ffast-math

	export RRDDOCDIR=${EPREFIX}/usr/share/doc/${PF}

	# to solve bug #260380
	[[ ${CHOST} == *-solaris* ]] && append-flags -D__EXTENSIONS__

	# Stub configure.ac
	local myconf=()
	if ! use tcpd; then
		myconf+=( "--disable-libwrap" )
	fi
	if ! use dbi; then
		myconf+=( "--disable-libdbi" )
	fi

	econf \
		$(use_enable graph rrd_graph) \
		$(use_enable lua lua-site-install) \
		$(use_enable lua) \
		$(use_enable perl perl-site-install) \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable rrdcgi) \
		$(use_enable static-libs static) \
		$(use_enable tcl) \
		$(use_with tcl tcllib "${EPREFIX}"/usr/$(get_libdir)) \
		--with-perl-options=INSTALLDIRS=vendor \
		--disable-librados \
		--disable-ruby-site-install \
		--disable-ruby \
		${myconf[@]}
}

src_compile() {
	default

	use python && distutils-r1_src_compile
}

src_install() {
	default

	if ! use doc ; then
		rm -rf "${ED}"usr/share/doc/${PF}/{html,txt}
	fi

	if use !rrdcgi ; then
		# uses rrdcgi, causes invalid shebang error in Prefix, useless
		# without rrdcgi installed
		rm -f "${ED}"usr/share/${PN}/examples/cgi-demo.cgi
	fi

	if use perl ; then
		perl_delete_localpod
		perl_delete_packlist
	fi

	dodoc CHANGES CONTRIBUTORS NEWS THREADS TODO

	find "${ED}"usr -name '*.la' -exec rm -f {} +

	keepdir /var/lib/rrdcached/journal/
	keepdir /var/lib/rrdcached/db/

	newconfd "${FILESDIR}"/rrdcached.confd rrdcached
	newinitd "${FILESDIR}"/rrdcached.init rrdcached

	use python && distutils-r1_src_install
}

pkg_postinst() {
	ewarn "Since version 1.3, rrdtool dump emits completely legal xml.  Basically this"
	ewarn "means that it contains an xml header and a DOCTYPE definition.  Unfortunately"
	ewarn "this causes older versions of rrdtool restore to be unhappy."
	ewarn
	ewarn "To restore a new dump with an old rrdtool restore version, either remove"
	ewarn "the xml header and the doctype by hand (both on the first line of the dump)"
	ewarn "or use rrdtool dump --no-header."
	ewarn
	ewarn ">=net-analyzer/rrdtool-1.3 does not have any default font bundled. Thus if"
	ewarn ">you've upgraded from rrdtool-1.2.x and don't have any font installed to make"
	ewarn ">lables visible, please, install some font, e.g.  media-fonts/dejavu."
}
