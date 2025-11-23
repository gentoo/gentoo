# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Maintain remote web sites with ease"
HOMEPAGE=" http://www.manyfish.co.uk/sitecopy/"
SRC_URI="
	mirror://gentoo/${P}.tar.gz
	https://dev.gentoo.org/~jstein/files/${P}-04-manpages-addition-fixes.patch
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="expat nls rsh ssl webdav xml zlib"

RDEPEND="
	rsh? ( net-misc/netkit-rsh )
	>=net-libs/neon-0.24.6[zlib?,ssl?,expat?]
	<net-libs/neon-0.35[zlib?,ssl?,expat?]
	xml? ( >=net-libs/neon-0.24.6:=[-expat] )
"
DEPEND="${RDEPEND}"

# SiteCopy patches are being currently pulled & ported from
# http://ftp.debian.org/debian/pool/main/s/sitecopy/ Consider SiteCopy to be
# more or less being actively maintained by Debian maintainers, but GPL patches
# ported into Gentoo.
# Update 2024-10-13: There appears to be a (new?) upstream repository,
# see metadata.xml remote-id.
PATCHES=(
	"${FILESDIR}/${P}-01-remote-dynamic-rc.patch"
	"${FILESDIR}/${P}-02-french-po-fix.patch"
	"${FILESDIR}/${P}-03-wrong-memory-397155.patch"
	"${FILESDIR}/${P}-06-sftpdriver.c-fix-for-new-openssh.patch"
	"${FILESDIR}/${P}-10-bts410703-preserve-storage-files-sigint.patch"
	"${FILESDIR}/${P}-20-neon-compatibility-up-to-0.34.patch"
	"${FILESDIR}/${P}-30-bts320586-manpage-document-sftp.patch"
	"${FILESDIR}/${P}-32-neon-0.31.patch"
	"${FILESDIR}/${P}-33-c99-build-fix.patch"

	"${DISTDIR}/${P}-04-manpages-addition-fixes.patch"
)

src_prepare() {
	default

	# Source package uses incorrect '/usr/doc' for the doc folder.  So use
	# sed to correct this error.
	sed -i -e "s:docdir \= .*:docdir \= \$\(prefix\)\/share/doc\/${PF}:" \
		Makefile.in || die "Documentation directory patching failed"

	mv configure.in configure.ac || die
	eautoconf
	eautomake
}

src_configure() {
	local myconf=(
		$(use_enable nls)
		$(use_enable rsh)
		$(use_enable webdav)
		$(use_with expat)
		$(use_with ssl ssl openssl)
		$(use_with xml libxml2 )
		--with-neon
	)
	econf "${myconf[@]}"
}
