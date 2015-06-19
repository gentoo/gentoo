# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/gearmand/gearmand-0.34-r1.ebuild,v 1.4 2014/12/28 16:57:22 titanofold Exp $

EAPI=5

inherit flag-o-matic libtool user autotools-utils

DESCRIPTION="Generic framework to farm out work to other machines"
HOMEPAGE="http://www.gearman.org/"
SRC_URI="http://launchpad.net/gearmand/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug tcmalloc +memcache drizzle sqlite tokyocabinet postgres"

RDEPEND="dev-libs/libevent
	>=dev-libs/boost-1.39:=[threads(+)]
	|| ( >=sys-apps/util-linux-2.16 <sys-libs/e2fsprogs-libs-1.41.8 )
	tcmalloc? ( dev-util/google-perftools )
	memcache? ( >=dev-libs/libmemcached-0.47 )
	drizzle? ( dev-db/drizzle )
	sqlite? ( dev-db/sqlite:3 )
	tokyocabinet? ( dev-db/tokyocabinet )
	postgres? ( >=dev-db/postgresql-9.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	enewuser gearmand -1 -1 /dev/null nogroup
}

src_configure() {
	local myeconfargs=(
		$(use_enable drizzle libdrizzle)
		$(use_enable memcache libmemcached)
		$(use_enable postgres libpq)
		$(use_enable tcmalloc)
		$(use_enable tokyocabinet libtokyocabinet)
		$(use_with sqlite sqlite3)
		--disable-mtmalloc
		--disable-static
	)

	# Don't ever use --enable-assert since configure.ac is broken, and
	# only does --disable-assert correctly.
	if use debug; then
		# Since --with-debug would turn off optimisations as well as
		# enabling debug, we just enable debug through the
		# preprocessor then.
		append-cppflags -DDEBUG
	fi

	autotools-utils_src_configure
}

src_test() {
	# Since libtool is stupid and doesn't discard /usr/lib64 from the
	# load path, we'd end up testing against the installed copy of
	# gearmand (bad).
	#
	# We thus cheat and "fix" the scripts by hand.
	sed -i -e '/LD_LIBRARY_PATH=/s|/usr/lib64:||' "${BUILD_DIR}"/tests/*_test \
		|| die "test fixing failed"

	autotools-utils_src_test
}

DOCS=( README AUTHORS ChangeLog )

src_install() {
	autotools-utils_src_install

	newinitd "${FILESDIR}"/gearmand.init.d.2 gearmand
	newconfd "${FILESDIR}"/gearmand.conf.d gearmand
}

pkg_postinst() {
	elog ""
	elog "Unless you set the PERSISTENT_TABLE option in"
	elog "/etc/conf.d/gearmand, Gearmand will use table 'queue'."
	elog "If such table doesn't exist, Gearmand will create it for you"
	elog ""
}
