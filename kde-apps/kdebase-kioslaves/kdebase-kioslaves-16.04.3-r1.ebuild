# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kde-runtime"
KMMODULE="kioslave"
WEBKIT_REQUIRED="optional"
inherit kde4-meta

KEYWORDS="~amd64 ~arm ~x86"
DESCRIPTION="KDE VFS framework - kioslaves present a filesystem-like view of arbitrary data"
IUSE="+bzip2 exif debug lzma openexr samba +sftp"

# tests hang, last checked for 4.2.96
RESTRICT="test"

DEPEND="
	virtual/jpeg:0
	!aqua? ( x11-libs/libXcursor )
	bzip2? ( app-arch/bzip2 )
	exif? ( media-gfx/exiv2:= )
	openexr? ( media-libs/openexr:= )
	samba? ( || ( <net-fs/samba-4.0.0_alpha1[smbclient] >=net-fs/samba-4.0.0_alpha1[client] ) )
	sftp? ( >=net-libs/libssh-0.4.0:=[sftp] )
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kdelibs 'bzip2?,lzma?')
	$(add_kdeapps_dep kdialog)
	virtual/ssh
	!aqua? ( !kernel_SunOS? ( virtual/eject ) )
"

KMEXTRA="
	kioexec
	kdeeject
"

PATCHES=(
	"${FILESDIR}/${P}-webkit.patch"
	"${FILESDIR}/${P}-perl-5.22.patch"
)

src_configure() {
	local mycmakeargs=(
		-DWITH_SLP=OFF
		-DWITH_BZip2=$(usex bzip2)
		-DWITH_Exiv2=$(usex exif)
		-DWITH_LibLZMA=$(usex lzma)
		-DWITH_OpenEXR=$(usex openexr)
		-DWITH_Samba=$(usex samba)
		-DWITH_LibSSH=$(usex sftp)
		-DWITH_KDEWEBKIT=$(usex webkit)
	)

	kde4-meta_src_configure
}
