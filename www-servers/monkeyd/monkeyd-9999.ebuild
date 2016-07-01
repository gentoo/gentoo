# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs user multilib

DESCRIPTION="A small, fast, and scalable web server"
HOMEPAGE="http://www.monkey-project.com/"
MY_P="${PN/d}-${PV}"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/monkey/monkey.git"
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="http://monkey-project.com/releases/${PV:0:3}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

# jemalloc is also off until we figure out how to work CMakeLists.txt magic.
#IUSE="cgi -debug fastcgi jemalloc php static-plugins ${PLUGINS}"

PLUGINS="monkeyd_plugins_auth monkeyd_plugins_cheetah monkeyd_plugins_dirlisting +monkeyd_plugins_liana monkeyd_plugins_logger monkeyd_plugins_mandril monkeyd_plugins_tls"
IUSE="cgi -debug fastcgi php static-plugins ${PLUGINS}"

# uclibc is often compiled without backtrace info so we should
# force this off.  If someone complains, consider relaxing it.
REQUIRED_USE="
	monkeyd_plugins_tls? ( !static-plugins )
	elibc_uclibc? ( !debug )
	cgi? ( php )"

#DEPEND="jemalloc? ( >=dev-libs/jemalloc-3.3.1 )"
DEPEND="
	dev-util/cmake
	monkeyd_plugins_tls? ( net-libs/mbedtls:= )"
RDEPEND="
	php? ( dev-lang/php )
	cgi? ( dev-lang/php[cgi] )"

S="${WORKDIR}/${MY_P}"

WEBROOT="/var/www/localhost"

pkg_preinst() {
	enewgroup monkeyd
	enewuser monkeyd -1 -1 /var/tmp/monkeyd monkeyd
}

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
	epatch "${FILESDIR}"/${PN}-1.6.9-fix-pidfile.patch
	epatch "${FILESDIR}"/${PN}-1.6.8-system-mbedtls.patch
}

src_configure() {
	local myconf=""

	use elibc_uclibc && myconf+=" --uclib-mode"
	use elibc_musl && myconf+=" --musl-mode"

	#use jemalloc || myconf+=" --malloc-libc"
	myconf+=" --malloc-libc"

	if use debug; then
		myconf+=" --debug --trace"
	else
		myconf+=" --no-backtrace"
	fi

	local enable_plugins=""
	local disable_plugins=""
	# We use 'cgi' and 'fastcgi' because they are global flags
	# instead of the corresponding monkeyd_plugins_*
	use cgi && enable_plugins+="cgi," || disable_plugins+="cgi,"
	use fastcgi && enable_plugins+="fastcgi," || disable_plugins+="fastcgi,"
	# For the rest, we scan the monkeyd_plugins_* and parse out the plugin name.
	local p
	for p in ${PLUGINS}; do
		pp=${p/+/}
		cp=${pp/monkeyd_plugins_/}
		use $pp && enable_plugins+="${cp}," || disable_plugins+="${cp},"
	done
	myconf+=" --enable-plugins=${enable_plugins%,} --disable-plugins=${disable_plugins%,}"
	if use static-plugins; then
		myconf+=" --static-plugins=${enable_plugins%,}"
	fi

	# For O_CLOEXEC which is guarded by _GNU_SOURCE in uClibc,
	# but shouldn't because it is POSIX.  This needs to be fixed
	# in uClibc.  Also, we really should us append-cppflags but
	# monkey's build system doesn't respect CPPFLAGS.  This needs
	# to be fixed in monkey.
	use elibc_uclibc && append-cflags -D_GNU_SOURCE

	# Non-autotools configure
	./configure \
		--pthread-tls \
		--prefix=/usr \
		--default-user=monkeyd \
		--sbindir=/usr/sbin \
		--webroot=${WEBROOT}/htdocs \
		--logdir=/var/log/monkeyd \
		--mandir=/usr/share/man \
		--libdir=/usr/$(get_libdir) \
		--sysconfdir=/etc/monkeyd \
		${myconf} \
		|| die
}

src_compile() {
	emake VERBOSE=1
}

src_install() {
	default

	newinitd "${FILESDIR}"/monkeyd.initd-r1 monkeyd
	newconfd "${FILESDIR}"/monkeyd.confd monkeyd

	# Move htdocs to docdir, bug #429632
	docompress -x /usr/share/doc/"${PF}"/htdocs.dist
	mv "${D}"${WEBROOT}/htdocs \
		"${D}"/usr/share/doc/"${PF}"/htdocs.dist || die

	keepdir \
		/var/tmp/monkeyd \
		/var/log/monkeyd \
		${WEBROOT}/htdocs

	# This needs to be created at runtime
	rm -rf "${D}"/run
}

pkg_postinst() {
	chown monkeyd:monkeyd /var/{log,tmp}/monkeyd
	chmod 770 /var/{log,tmp}/monkeyd
}
