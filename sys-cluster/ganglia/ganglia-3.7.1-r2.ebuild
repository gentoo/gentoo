# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 flag-o-matic systemd toolchain-funcs

DESCRIPTION="A scalable distributed monitoring system for clusters and grids"
HOMEPAGE="http://ganglia.sourceforge.net/"
SRC_URI="mirror://sourceforge/ganglia/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="minimal pcre python examples"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="dev-libs/confuse
	dev-libs/expat
	>=dev-libs/apr-1.0
	net-libs/libnsl:0=
	net-libs/libtirpc:0=
	!dev-db/firebird
	pcre? ( dev-libs/libpcre )
	python? ( ${PYTHON_DEPS} )"

RDEPEND="
	${DEPEND}
	!minimal? ( net-analyzer/rrdtool )"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	if use python && ! use minimal; then
		pushd gmetad-python >/dev/null || die
		distutils-r1_src_prepare
		popd >/dev/null || die
	else
		default_src_prepare
	fi
}

src_configure() {
	if use python; then
		python_setup
	fi

	append-flags $("$(tc-getPKG_CONFIG)" --cflags libtirpc)
	append-libs $("$(tc-getPKG_CONFIG)" --libs libtirpc)

	econf \
		--with-systemdsystemunitdir=$(systemd_get_systemunitdir) \
		--enable-gexec \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--enable-static=no \
		$(use_enable python) \
		$(use_with pcre libpcre) \
		$(use_with !minimal gmetad)
}

src_compile() {
	default_src_compile

	if use python && ! use minimal; then
		pushd gmetad-python >/dev/null || die
		distutils-r1_src_compile
		popd >/dev/null || die
	fi
}

src_install() {
	local exdir=/usr/share/doc/${P}

	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/gmond.rc-2 gmond
	doman {mans/*.1,gmond/*.5}
	dodoc AUTHORS INSTALL NEWS README

	dodir /etc/ganglia/conf.d
	use python && dodir /usr/$(get_libdir)/ganglia/python_modules
	gmond/gmond -t > "${ED}"/etc/ganglia/gmond.conf

	if use examples; then
		insinto ${exdir}/cmod-examples
		doins gmond/modules/example/*.c
		if use python; then
			# Installing as an examples per upstream.
			insinto ${exdir}/pymod-examples
			doins gmond/python_modules/*/*.py
			insinto ${exdir}/pymod-examples/conf.d
			doins gmond/python_modules/conf.d/*.pyconf
		fi
	fi

	if ! use minimal; then
		insinto /etc/ganglia
		doins gmetad/gmetad.conf
		doman mans/gmetad.1

		newinitd "${FILESDIR}"/gmetad.rc-2 gmetad
		keepdir /var/lib/ganglia/rrds
		fowners nobody:nobody /var/lib/ganglia/rrds

		if use python; then
			pushd gmetad-python >/dev/null || die
			distutils-r1_src_install
			popd >/dev/null || die
			newinitd "${FILESDIR}"/gmetad-python.rc gmetad-python
		fi
	fi
}

src_test() {
	default_src_test

	if use python && ! use minimal; then
		pushd gmetad-python >/dev/null || die
		distutils-r1_src_test
		popd >/dev/null || die
	fi
}

pkg_postinst() {
	elog "A default configuration file for gmond has been generated"
	elog "for you as a template by running:"
	elog "    /usr/sbin/gmond -t > /etc/ganglia/gmond.conf"

	elog "The web frontend for Ganglia has been split off.  Emerge"
	elog "sys-cluster/ganglia-web if you need it."
}
