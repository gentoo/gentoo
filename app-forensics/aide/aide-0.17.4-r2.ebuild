# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools readme.gentoo-r1

DESCRIPTION="AIDE (Advanced Intrusion Detection Environment) is a file integrity checker"
HOMEPAGE="https://aide.github.io/ https://github.com/aide/aide"
SRC_URI="https://github.com/aide/aide/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="acl audit curl e2fs mhash selinux xattr zlib"

DEPEND="dev-libs/libpcre
	acl? ( virtual/acl )
	audit? ( sys-process/audit )
	curl? ( net-misc/curl )
	e2fs? ( sys-fs/e2fsprogs )
	!mhash? (
		dev-libs/libgcrypt:0=
		dev-libs/libgpg-error
	)
	mhash? ( app-crypt/mhash )
	selinux? ( sys-libs/libselinux )
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-aide )"
BDEPEND="sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig"

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="
Example configuration file was installed at '${EPREFIX}/etc/aide/aide.conf'.
Please edit it to meet your needs. Refer to aide.conf(5) manual page
for more information.

A helper script, aideinit, was installed and can be used to make AIDE
management easier. Please run 'aideinit --help' for more information."

PATCHES=(
	"${FILESDIR}"/${PN}-0.16-fix-acl-configure-option.patch
	"${FILESDIR}"/${PN}-0.17.4-bashism.patch
)

src_prepare() {
	default

	sed -i -e 's| -Werror||g' configure.ac || die

	# Only needed for snapshots.
	if [[ ${PV} == *_p* ]] ; then
		echo "m4_define([AIDE_VERSION], [${PV}])" > version.m4 || die
	fi

	# Can be dropped once Bashism patch is gone
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/${PN}

		# Disable broken l10n support: https://sourceforge.net/p/aide/bugs/98/
		# This doesn't affect anything because there are no localizations yet.
		--without-locale

		--without-prelink
		$(use_with zlib)
		$(use_with curl)
		$(use_with acl posix-acl)
		$(use_with selinux)
		$(use_with xattr)
		$(use_with e2fs e2fsattrs)
		$(use_with mhash mhash)
		$(use_with !mhash gcrypt)
		$(use_with audit)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	readme.gentoo_create_doc

	insinto /etc/${PN}
	insopts -m0600
	newins "${FILESDIR}"/aide.conf-r2 aide.conf

	dosbin "${FILESDIR}"/aideinit
	dodoc -r contrib/ "${FILESDIR}"/aide.cron-r2

	keepdir /var/{lib,log}/${PN}
}

pkg_postinst() {
	readme.gentoo_print_elog
}
