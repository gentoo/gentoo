# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools readme.gentoo-r1

DESCRIPTION="AIDE (Advanced Intrusion Detection Environment) is a file integrity checker"
HOMEPAGE="http://aide.sourceforge.net/"
SRC_URI="mirror://sourceforge/aide/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="acl audit curl e2fs mhash postgres prelink selinux xattr zlib"

COMMON_DEPEND="
	!mhash? (
		dev-libs/libgcrypt:0=
		dev-libs/libgpg-error
	)
	mhash? ( app-crypt/mhash )
	dev-libs/libpcre
	acl? ( virtual/acl )
	audit? ( sys-process/audit )
	curl? ( net-misc/curl )
	e2fs? ( sys-fs/e2fsprogs )
	postgres? ( dev-db/postgresql:= )
	prelink? ( dev-libs/elfutils )
	selinux? ( sys-libs/libselinux )
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )
"
RDEPEND="
	${COMMON_DEPEND}
	prelink? ( sys-devel/prelink )
	selinux? ( sec-policy/selinux-aide )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

REQUIRED_USE="
	postgres? ( !mhash )
"

HTML_DOCS=( doc/manual.html )

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="
Example configuration file was installed at '${EPREFIX}/etc/aide/aide.conf'.
Please edit it to meet your needs. Refer to aide.conf(5) manual page
for more information.

A helper script, aideinit, was installed and can be used to make AIDE
management easier. Please run 'aideinit --help' for more information.
"

PATCHES=(
	"${FILESDIR}/${P}-add-missing-include.patch"
	"${FILESDIR}/${P}-fix-LIBS-LDFLAGS-mixing.patch"
	"${FILESDIR}/${P}-fix-acl-configure-option.patch"
	"${FILESDIR}/${P}-support-attr-2.4.48.patch"
)

src_prepare() {
	default_src_prepare
	sed -i -e 's| -Werror||g' configure.ac || die
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
	default_src_install
	readme.gentoo_create_doc

	insinto /etc/${PN}
	doins "${FILESDIR}"/aide.conf

	dosbin "${FILESDIR}"/aideinit
	dodoc "${FILESDIR}"/aide.cron

	keepdir /var/{lib,log}/${PN}
}

pkg_postinst() {
	readme.gentoo_print_elog

	if use postgres; then
		elog
		elog "Due to a bad assumption by aide, you must issue the following"
		elog "command after the database initialization (aide --init ...):"
		elog
		elog 'psql -c "update pg_index set indisunique=false from pg_class \\ '
		elog "  where pg_class.relname='TABLE_pkey' and \ "
		elog '  pg_class.oid=pg_index.indexrelid" -h HOSTNAME -p PORT DBASE USER'
		elog
		elog "where TABLE, HOSTNAME, PORT, DBASE, and USER are the same as"
		elog "in your aide.conf."
		elog
	fi
}
