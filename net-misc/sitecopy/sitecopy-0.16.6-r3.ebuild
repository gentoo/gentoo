# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

DESCRIPTION="Maintain remote web sites with ease"
HOMEPAGE=" http://www.manyfish.co.uk/sitecopy/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	https://dev.gentoo.org/~jstein/files/sitecopy-0.16.6-04-manpages-addition-fixes.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="expat nls rsh ssl webdav xml zlib"

RDEPEND="
	rsh? ( net-misc/netkit-rsh )
	>=net-libs/neon-0.24.6[zlib?,ssl?,expat?]
	<=net-libs/neon-0.32.9999[zlib?,ssl?,expat?]
	xml? ( >=net-libs/neon-0.24.6:=[-expat] )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# SiteCopy patches are being currently pulled & ported from
	# http://ftp.debian.org/debian/pool/main/s/sitecopy/
	# Consider SiteCopy to be more or less being actively maintained by
	# Debian maintainers, but GPL patches ported into Gentoo.
	# Update 2024-10-13: There appears to be a (new?) upstream repository,
	# see metadata.xml remote-id.

	eapply \
		"${FILESDIR}/sitecopy-0.16.6-01-remote-dynamic-rc.patch" \
		"${FILESDIR}/sitecopy-0.16.6-02-french-po-fix.patch" \
		"${FILESDIR}/sitecopy-0.16.6-03-wrong-memory-397155.patch" \
		"${FILESDIR}/sitecopy-0.16.6-06-sftpdriver.c-fix-for-new-openssh.patch" \
		"${FILESDIR}/sitecopy-0.16.6-10-bts410703-preserve-storage-files-sigint.patch" \
		"${FILESDIR}/sitecopy-0.16.6-20-bts549721-add-compatibility-for-neon-0.29.0.patch" \
		"${FILESDIR}/sitecopy-0.16.6-30-bts320586-manpage-document-sftp.patch" \
		"${FILESDIR}/sitecopy-0.16.6-32-neon-0.31.patch" \
		"${FILESDIR}/sitecopy-0.16.6-33-c99-build-fix.patch" \
		"${DISTDIR}/sitecopy-0.16.6-04-manpages-addition-fixes.patch"

	# Source package uses incorrect '/usr/doc' for the doc folder.  So use
	# sed to correct this error.
	sed -i -e "s:docdir \= .*:docdir \= \$\(prefix\)\/share/doc\/${PF}:" \
		Makefile.in || die "Documentation directory patching failed"

	mv configure.in configure.ac || die
	eautoconf
	eautomake
}

src_configure() {
	econf \
		$(use_with ssl ssl openssl) \
		$(use_enable webdav) \
		$(use_enable nls) \
		$(use_enable rsh) \
		$(use_with expat) \
		$(use_with xml libxml2 ) \
		--with-neon
}
