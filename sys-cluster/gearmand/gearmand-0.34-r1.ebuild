# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils eutils flag-o-matic libtool user

DESCRIPTION="Generic framework to farm out work to other machines"
HOMEPAGE="http://www.gearman.org/"
SRC_URI="https://launchpad.net/gearmand/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug tcmalloc +memcache sqlite tokyocabinet postgres"

RDEPEND="dev-libs/libevent
	>=dev-libs/boost-1.39:=[threads(+)]
	|| ( >=sys-apps/util-linux-2.16 <sys-libs/e2fsprogs-libs-1.41.8 )
	tcmalloc? ( dev-util/google-perftools )
	memcache? ( >=dev-libs/libmemcached-0.47 )
	sqlite? ( dev-db/sqlite:3 )
	tokyocabinet? ( dev-db/tokyocabinet )
	postgres? ( >=dev-db/postgresql-9.0:* )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/boost-m4-0.4_p20160328"

pkg_setup() {
	enewuser gearmand -1 -1 /dev/null nogroup
}

src_prepare() {
	# fixes bug 574558, which is due to an outdated bundled boost.m4
	rm m4/boost.m4 || die
	sed -i -e 's/AM_INIT_AUTOMAKE.*//g' m4/pandora_canonical.m4 || die
	epatch -p1 "${FILESDIR}/${P}-stdbool-h.patch"
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable memcache libmemcached)
		$(use_enable tcmalloc)
		$(use_enable tokyocabinet libtokyocabinet)
		$(use_with postgres postgresql)
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

	# Explicitly enable c++11 mode
	append-cxxflags -std=c++11

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
