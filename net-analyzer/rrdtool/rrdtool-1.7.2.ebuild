# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DISTUTILS_OPTIONAL=true
DISTUTILS_SINGLE_IMPL=true
GENTOO_DEPEND_ON_PERL=no
PYTHON_COMPAT=( python3_{6,7,8} )
inherit autotools perl-module distutils-r1 flag-o-matic multilib

MY_P=${P/_/-}

DESCRIPTION="A system to store and display time-series data"
HOMEPAGE="https://oss.oetiker.ch/rrdtool/"
SRC_URI="https://oss.oetiker.ch/rrdtool/pub/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/8.0.0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="dbi doc graph lua perl python rados rrdcgi ruby static-libs tcl tcpd test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="
	>=dev-libs/glib-2.28.7:2[static-libs(+)?]
	>=dev-libs/libxml2-2.7.8:2[static-libs(+)?]
	dbi? ( dev-db/libdbi[static-libs(+)?] )
	graph? (
		>=media-libs/libpng-1.5.10:0=[static-libs(+)?]
		>=x11-libs/cairo-1.10.2[svg,static-libs(+)?]
		>=x11-libs/pango-1.28
	)
	lua? ( dev-lang/lua:0=[deprecated] )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	rados? ( sys-cluster/ceph )
	tcl? ( dev-lang/tcl:0= )
	tcpd? ( sys-apps/tcp-wrappers )
"

DEPEND="
	${CDEPEND}
	sys-apps/groff
	virtual/pkgconfig
	virtual/awk
	test? ( sys-devel/bc )
"
RDEPEND="
	${CDEPEND}
"
PDEPEND="
	ruby? ( ~dev-ruby/rrdtool-bindings-${PV} )
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.4.9-disable-rrd_graph-perl.patch
	"${FILESDIR}"/${PN}-1.7.0-disable-rrd_graph-cgi.patch
	"${FILESDIR}"/${PN}-1.7.1-configure.ac.patch
)
S=${WORKDIR}/${MY_P}

python_compile() {
	cd bindings/python || die
	distutils-r1_python_compile
}

python_install() {
	cd bindings/python || die
	distutils-r1_python_install
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	# At the next version bump, please see if you actually still need this
	# before adding versions
	if ! [ -f doc/rrdrados.pod ]; then
		cp "${FILESDIR}"/${PN}-1.5.5-rrdrados.pod doc/rrdrados.pod
	else
		die "File already exists: doc/rrdrados.pod. Remove this code!"
	fi

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

	if ! use graph; then
		sed -i \
			-e '2s:rpn1::; 2s:rpn2::; 6s:create-with-source-4::;' \
			-e '7s:xport1::; 7s:dcounter1::; 7s:vformatter1::' \
			-e 's|graph1||g' \
			tests/Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	export rd_cv_gcc_flag__Werror=no
	export rd_cv_ms_async=ok

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
	if ! use rados; then
		myconf+=( "--disable-librados" )
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
		--disable-ruby-site-install \
		--disable-ruby \
		${myconf[@]}
}

src_compile() {
	default

	use python && distutils-r1_src_compile
}

src_test() {
	export LC_ALL=C
	default
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
