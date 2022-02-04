# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools readme.gentoo-r1

DESCRIPTION="AIDE (Advanced Intrusion Detection Environment) is a file integrity checker"
HOMEPAGE="https://aide.github.io/ https://github.com/aide/aide"

COMMIT="7949feff20501724a43929ee7894b005812ffb4f" # 20200614
SRC_URI="https://github.com/aide/aide/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="acl audit curl e2fs mhash postgres prelink selinux xattr zlib"

REQUIRED_USE="
	postgres? ( !mhash )
	"

COMMON_DEPEND="
	dev-libs/libpcre
	acl? ( virtual/acl )
	audit? ( sys-process/audit )
	curl? ( net-misc/curl )
	e2fs? ( sys-fs/e2fsprogs )
	!mhash? (
		dev-libs/libgcrypt:0=
		dev-libs/libgpg-error
	)
	mhash? ( app-crypt/mhash )
	postgres? ( dev-db/postgresql:= )
	prelink? ( dev-libs/elfutils )
	selinux? ( sys-libs/libselinux )
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )"

RDEPEND="
	${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-aide )"

DEPEND="${COMMON_DEPEND}"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	prelink? ( sys-devel/prelink )"

HTML_DOCS=( doc/manual.html )

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="
Example configuration file was installed at '${EPREFIX}/etc/aide/aide.conf'.
Please edit it to meet your needs. Refer to aide.conf(5) manual page
for more information.

A helper script, aideinit, was installed and can be used to make AIDE
management easier. Please run 'aideinit --help' for more information."

PATCHES=(
	"${FILESDIR}/aide-0.16-fix-LIBS-LDFLAGS-mixing.patch"
	"${FILESDIR}/aide-0.16-fix-acl-configure-option.patch"

	# Remove not available gcrypt algorithm 7 DB_HAVAL
	# See: https://sourceforge.net/p/aide/bugs/105/
	"${FILESDIR}/${P}_define_hash_use_gcrypt.patch"
)

S="${WORKDIR}/${PN}-${COMMIT}"

pkg_setup() {
	if use postgres; then
		ewarn "\nWARNING!"
		ewarn "You need to choose one of the postgres versions before building"
		ewarn "\nPlease select a target postgres version/slot using:\n"
		ewarn "    ~# eselect postgresql list"
		ewarn "    ~# eselect postgresql set <version>\n"
	fi
}

src_prepare() {
	default
	sed -i -e 's| -Werror||g' configure.ac || die
	echo "m4_define([AIDE_VERSION], [${PV}])" > version.m4 || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}/etc/${PN}"
		--with-confighmactype="sha512"		# Override default weak MD5 hash.
		--with-dbhmackey="sha512"			# Override default weak MD5 hash.
		# Disable broken l10n support: https://sourceforge.net/p/aide/bugs/98/
		# This doesn't affect anything because there are no localizations yet.
		--without-locale
		--disable-static
		$(use_with zlib)
		$(use_with curl)
		$(use_with acl posix-acl)
		$(use_with selinux)
		$(use_with prelink prelink "${EPREFIX}/usr/sbin/prelink")
		$(use_with xattr)
		$(use_with e2fs e2fsattrs)
		$(use_with mhash mhash)
		$(use_with !mhash gcrypt)
		$(use_with postgres psql)
		$(use_with audit)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	readme.gentoo_create_doc

	insinto /etc/${PN}
	insopts -m0600
	newins "${FILESDIR}"/aide.conf-r1 aide.conf

	dosbin "${FILESDIR}"/aideinit
	dodoc -r contrib/ "${FILESDIR}"/aide.cron

	keepdir /var/{lib,log}/${PN}
}

pkg_postinst() {
	readme.gentoo_print_elog

	if use postgres; then
		elog "\nDue to a bad assumption by aide, you must issue the following"
		elog "command after the database initialization (aide --init ...):"
		elog '\n    ~# psql -c "update pg_index set indisunique=false from pg_class \\ '
		elog "          where pg_class.relname='TABLE_pkey' and \ "
		elog '          pg_class.oid=pg_index.indexrelid" -h HOSTNAME -p PORT DBASE USER'
		elog "\nwhere TABLE, HOSTNAME, PORT, DBASE, and USER are the same as"
		elog "in your aide.conf.\n"
	fi
}
