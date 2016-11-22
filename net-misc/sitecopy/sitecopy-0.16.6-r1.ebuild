# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="Maintain remote web sites with ease"
SRC_URI="http://www.manyfish.co.uk/sitecopy/${P}.tar.gz
	https://dev.gentoo.org/~idella4/sitecopy-0.16.6-04-manpages-addition-fixes.patch"
HOMEPAGE=" http://www.manyfish.co.uk/sitecopy/"
# Removed all Debian related stuff.  If you want more patches, they can be ported from
# http://ftp.debian.org/debian/pool/main/s/sitecopy/
# The sitecopy_0.16.6-5.debian.tar.gz contains their build scripts and patches.
# This SiteCopy now builds using the original sources.
KEYWORDS="amd64 x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="expat nls rsh ssl webdav xml zlib"

# TODO: Depends copied over from old ebuild file, ensure they're still correct!
DEPEND="rsh? ( net-misc/netkit-rsh )
	>=net-libs/neon-0.24.6[zlib?,ssl?,expat?]
	<=net-libs/neon-0.30.9999[zlib?,ssl?,expat?]
	xml? ( >=net-libs/neon-0.24.6[-expat] )"
RDEPEND="${DEPEND}"

src_prepare() {
	# NOTE: Insert patches here.
	# SiteCopy patches are being currently pulled & ported from
	# http://ftp.debian.org/debian/pool/main/s/sitecopy/
	# Consider SiteCopy to be more or less being actively maintained by
	# Debian maintainers, but GPL patches ported into Gentoo.

	# NOTE: epatch is provided by 'inherit eutils'
	# Patch File Naming Format
	# files/package_name - package_version - patch_order - patch_description

	epatch "${FILESDIR}/sitecopy-0.16.6-01-remote-dynamic-rc.patch" \
	"${FILESDIR}/sitecopy-0.16.6-02-french-po-fix.patch" \
	"${FILESDIR}/sitecopy-0.16.6-03-wrong-memory-397155.patch" \
	"${FILESDIR}/sitecopy-0.16.6-06-sftpdriver.c-fix-for-new-openssh.patch" \
	"${FILESDIR}/sitecopy-0.16.6-10-bts410703-preserve-storage-files-sigint.patch" \
	"${FILESDIR}/sitecopy-0.16.6-20-bts549721-add-compatibility-for-neon-0.29.0.patch" \
	"${FILESDIR}/sitecopy-0.16.6-30-bts320586-manpage-document-sftp.patch" \
	"${DISTDIR}/sitecopy-0.16.6-04-manpages-addition-fixes.patch"

	# Source package uses incorrect '/usr/doc' for the doc folder.  So use
	# sed to correct this error.
	sed -i -e "s:docdir \= .*:docdir \= \$\(prefix\)\/share/doc\/${PF}:" \
		Makefile.in || die "Documentation directory patching failed"

	# NOTE: eautoconf/eautomake is provided by 'inherit autotools'
	# Need to recreate the source package provided configure script,
	# because the package provided configure script only supports
	# <neon-0.30.0 support.  A patch above patches the configure.in
	# providing neon-0.30.0 support, and we then recreate the configure
	# script based upon configure.in using autotools.

	# First move configure.in to configure.ac, required by newer >autoconf-2.13
	# per Bug #426262 automake-1.14 compatibility
	# Should check first, autoconf-2.13 is still in the tree requiring configure.in!
	# mv configure.in configure.ac || die

	eautoconf
	eautomake
}

src_configure() {
	# TODO: USE functions copied over from old ebuild file, ensure they're still correct!
	econf $(use_with ssl ssl openssl) \
		$(use_enable webdav) \
		$(use_enable nls) \
		$(use_enable rsh) \
		$(use_with expat) \
		$(use_with xml libxml2 ) \
		--with-neon \
		|| die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
