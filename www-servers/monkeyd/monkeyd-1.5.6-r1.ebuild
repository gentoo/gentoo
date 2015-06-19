# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/monkeyd/monkeyd-1.5.6-r1.ebuild,v 1.3 2015/06/18 22:42:26 blueness Exp $

EAPI="5"

inherit toolchain-funcs depend.php multilib

MY_P="${PN/d}-${PV}"
DESCRIPTION="A small, fast, and scalable web server"
HOMEPAGE="http://www.monkey-project.com/"
SRC_URI="http://monkey-project.com/releases/${PV:0:3}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ppc ppc64 ~x86"

# ssl is broken, so we turn it off until fixed
IUSE="-debug jemalloc php minimal elibc_musl elibc_uclibc monkeyd_plugins_auth monkeyd_plugins_cheetah cgi monkeyd_plugins_dirlisting fastcgi +monkeyd_plugins_liana monkeyd_plugins_logger monkeyd_plugins_mandril"

# uclibc is often compiled without backtrace info so we should
# force this off.  If someone complains, consider relaxing it.
# ssl is borken, so we remove "ssl? ( monkeyd_plugins_polarssl )"
REQUIRED_USE="
	elibc_uclibc? ( !debug )
	cgi? ( php )"

DEPEND="jemalloc? ( >=dev-libs/jemalloc-3.3.1 )"
RDEPEND="
	php? ( dev-lang/php )
	cgi? ( dev-lang/php[cgi] )"

S="${WORKDIR}/${MY_P}"

WEBROOT="/var/www/localhost"

pkg_setup() {
	if use debug; then
		ewarn
		ewarn "\033[1;33m**************************************************\033[00m"
		ewarn "Do not use debug in production!"
		ewarn "\033[1;33m**************************************************\033[00m"
		ewarn
	fi
}

src_prepare() {
	# Unconditionally get rid of the bundled jemalloc
	rm -rf "${S}"/deps
	epatch "${FILESDIR}"/${PN}-1.5.2-use-system-jemalloc.patch
	epatch "${FILESDIR}"/${PN}-1.5.0-fix-CPPFLAGS.patch

	# Don't install the banana script, we use ${FILESDIR}/monkeyd.initd instead
	sed -i '/Creating bin\/banana/d' configure || die "No configure file"
	sed -i '/create_banana_script bindir/d' configure || die "No configure file"

	# Don't explicitly strip files
	sed -i -e '/$STRIP /d' -e 's/install -s -m 644/install -m 755/' configure || die "No configure file"

	# We don't need the includes, sym link to libmonkey.so, or monkey.cp when not installing the .so
	use minimal && {
		sed -i '/install -d \\$(INCDIR)/d' configure || die "No configure file"
		sed -i '/install -m 644 src\/include\/\*.h \\$(INCDIR)/d' configure || die "No configure file"
		sed -i '/ln -sf/d' configure || die "No configure file"
		sed -i '/install -d \\$(LIBDIR)\/pkgconfig/d' configure || die "No configure file"
		sed -i '/install -m 644 monkey.pc \\$(LIBDIR)\/pkgconfig/d' configure || die "No configure file"
	}

	# Unquiet build
	sed -i '/^CC\s/d' configure || die "No configure file"
	sed -i 's/^\(CC_QUIET=\).*/\1 \\\$(CC)/' configure || die "No configure file"
	sed -i 's/^\(.*MAKE.*\)-s\(.*\)$/\1\2/' configure || die "No configure file"
	makes=$(find . -iname Makefile.in)
	for f in ${makes}; do
		sed -i '/^CC\s/d' $f || die "No file "$f
		sed -i 's/^\(CC_QUIET=\).*/\1 \$(CC)/' $f || die "No file "$f
	done
}

src_configure() {
	local myconf=""

	use elibc_uclibc && myconf+=" --uclib-mode"
	use elibc_musl && myconf+=" --musl-mode"

	use minimal || myconf+=" --enable-shared"
	use jemalloc || myconf+=" --malloc-libc"

	if use debug; then
		myconf+=" --debug --trace"
	else
		myconf+=" --no-backtrace"
	fi

	local enable_plugins=""
	local disable_plugins=""
	for p in ${PLUGINS}; do
		cp=${p/monkeyd_plugins_/}
		use $p && enable_plugins+="${cp}," || disable_plugins+="${cp},"
	done
	myconf+=" --enable-plugins=${enable_plugins%,} --disable-plugins=${disable_plugins%,}"

	# Non-autotools configure
	./configure \
		--prefix=/usr \
		--bindir=/usr/bin \
		--datadir=${WEBROOT}/htdocs \
		--logdir=/var/log/${PN} \
		--mandir=/usr/share/man \
		--libdir=/usr/$(get_libdir) \
		--pidfile=/run/monkey.pid \
		--plugdir=/usr/$(get_libdir)/monkeyd/plugins \
		--sysconfdir=/etc/${PN} \
		--platform="generic" \
		${myconf} \
		|| die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"

	# Don't install the banana script man page
	rm "${S}"/man/banana.1
}

src_install() {
	default

	if use php ; then
		sed -i -e '/^#AddScript application\/x-httpd-php/s:^#::' "${D}"/etc/monkeyd/monkey.conf || die
		sed -i -e 's:/home/my_home/php/bin/php:/usr/bin/php-cgi:' "${D}"/etc/monkeyd/monkey.conf || die
	fi

	sed -i -e "s:/var/log/monkeyd/monkey.pid:/var/run/monkey.pid:" "${D}"/etc/monkeyd/monkey.conf || die
	newinitd "${FILESDIR}"/monkeyd.initd monkeyd
	newconfd "${FILESDIR}"/monkeyd.confd monkeyd

	#move htdocs to docdir, bug #429632
	docompress -x /usr/share/doc/"${PF}"/htdocs.dist
	mv "${D}"${WEBROOT}/htdocs \
		"${D}"/usr/share/doc/"${PF}"/htdocs.dist
	mkdir "${D}"${WEBROOT}/htdocs

	keepdir \
		/var/log/monkeyd \
		${WEBROOT}/htdocs
}
