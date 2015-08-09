# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

WANT_AUTOMAKE="1.11"

PYTHON_COMPAT=( python2_7 )

inherit autotools python-r1 eutils multilib pam systemd user

DESCRIPTION="An extremely fast and tiny web server"
SRC_URI="https://github.com/cherokee/webserver/archive/v${PV}.zip -> ${P}.zip"
HOMEPAGE="http://www.cherokee-project.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE="admin ffmpeg debug geoip ipv6 kernel_linux ldap mysql nls pam php rrdtool ssl static static-libs"

COMMON_DEPEND="dev-libs/libpcre
	>=sys-libs/zlib-1.1.4-r1
	ffmpeg? ( virtual/ffmpeg )
	geoip? ( dev-libs/geoip )
	ldap? ( net-nds/openldap )
	mysql? ( >=virtual/mysql-5 )
	nls? ( virtual/libintl )
	pam? ( virtual/pam )
	php? ( || (
		dev-lang/php[fpm]
		dev-lang/php[cgi]
	) )
	ssl? ( dev-libs/openssl )"
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${COMMON_DEPEND}
	rrdtool? ( net-analyzer/rrdtool )"

RESTRICT="test"

WEBROOT="/var/www/localhost"

src_unpack() {
	unpack ${A}
	mv "webserver-${PV}" "${S}" || die
}

pkg_setup() {
	enewgroup cherokee
	enewuser cherokee -1 -1 /var/www cherokee
}

src_prepare() {
	python_setup
	epatch \
		"${FILESDIR}/${PN}-1.2.99-gentoo.patch"

	"${S}/po/admin/generate_POTFILESin.py" > po/admin/POTFILES.in
	eautoreconf
}

src_configure() {
	local myconf

	if use admin ; then
		myconf="${myconf} --enable-admin --with-python=/usr/bin/python"
	else
		myconf="${myconf} --disable-admin"
	fi

	# Uses autodetect because --with-php requires path to php-{fpm,cgi}.
	if ! use php ; then
		myconf="${myconf} --without-php"
	fi

	if use static ; then
		myconf="${myconf} --enable-static-module=all"
	fi

	local os="Unknown"
	case "${CHOST}" in
		*-freebsd*)
			os="FreeBSD" ;;
		*-netbsd*)
			os="NetBSD" ;;
		*-openbsd*)
			os="OpenBSD" ;;
		*)
			os="Linux" ;;
	esac

	econf \
		$(use_enable debug trace) \
		$(use_enable debug backtraces) \
		$(use_enable ipv6) \
		$(use_enable kernel_linux epoll) \
		$(use_enable nls) \
		$(use_enable pam) \
		$(use_enable static-libs static) \
		$(use_with ffmpeg) \
		$(use_with geoip) \
		$(use_with ldap) \
		$(use_with mysql) \
		$(use_with ssl libssl) \
		--disable-dependency-tracking \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--enable-os-string="Gentoo ${os}" \
		--enable-tmpdir="${EPREFIX}/var/tmp" \
		--localstatedir="${EPREFIX}/var" \
		--with-wwwroot="${EPREFIX}${WEBROOT}/htdocs" \
		--with-cgiroot="${EPREFIX}${WEBROOT}/cgi-bin" \
		--with-wwwuser=cherokee \
		--with-wwwgroup=cherokee \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -delete || die
	elif ! use static ; then
		find "${ED}/usr/$(get_libdir)/cherokee" '(' -name '*.la' -o -name '*.a' ')' -delete || die
	fi

	dodoc AUTHORS NEWS README.rst

	if use pam ; then
		pamd_mimic system-auth cherokee auth account session || die
	fi

	newinitd "${FILESDIR}/${PN}-initd-1.2.99" ${PN}
	newconfd "${FILESDIR}/${PN}-confd-1.2.98" ${PN}

	if ! use admin ; then
		rm -r \
			"${ED}"/usr/bin/cherokee-admin-launcher \
			"${ED}"/usr/bin/CTK-run \
			"${ED}"/usr/sbin/cherokee-admin \
			"${ED}"/usr/share/cherokee/admin || die
	fi

	exeinto /usr/share/doc/${PF}/contrib
	doexe contrib/{bin2buffer.py,make-cert.sh,make-dh_params.sh,tracelor.py}

	#move the htdocs to docdir, bug #429632
	docompress -x /usr/share/doc/"${PF}"/htdocs.dist
	mv "${ED}"${WEBROOT}/htdocs \
		"${ED}"/usr/share/doc/"${PF}"/htdocs.dist
	mkdir "${ED}"${WEBROOT}/htdocs

	keepdir \
		"${WEBROOT}"/htdocs \
		/var/log/cherokee \
		/var/lib/cherokee/graphs/images
	fowners cherokee:cherokee \
		/var/log/cherokee \
		/var/lib/cherokee/graphs \
		/var/lib/cherokee/graphs/images

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate-r1 ${PN}

	systemd_dounit "${FILESDIR}"/cherokee.service
}

pkg_postinst() {
	elog
	if use admin ; then
		elog "Just run '/usr/sbin/cherokee-admin' and go to: http://localhost:9090"
		elog
		elog "Cherokee currently supports configuration versioning, so from now on,"
		elog "whenever a change is made to the configuration file format,"
		elog "Cherokee-Admin will be able to automatically convert yours to the new"
		elog "release. You simply have to load Cherokee-Admin and it will be converted"
		elog "once you proceed to saving it."
		elog
		elog "There is also a command line utility that you can use to do the exact"
		elog "same thing. Config format can change in different versions. It is"
		elog "provided under:"
		elog "	${EPREFIX}/usr/share/cherokee/admin/upgrade_config.py"
	else
		elog "Try USE=admin if you want an easy way to configure cherokee."
	fi
	elog
	elog "emerge www-servers/spawn-fcgi if you use Ruby on Rails with ${PN}."
	elog
}
