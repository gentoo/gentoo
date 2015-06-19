# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/eagle/eagle-7.1.0.ebuild,v 1.3 2015/06/14 18:51:43 ulm Exp $

EAPI="5"

inherit eutils

DESCRIPTION="CadSoft EAGLE schematic and printed circuit board (PCB) layout editor"
HOMEPAGE="http://www.cadsoft.de"
SRC_URI="ftp://ftp.cadsoft.de/${PN}/program/${PV%\.[0-9]}/${PN}-lin-${PV}.run"

LICENSE="cadsoft"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE="doc linguas_de linguas_zh"

QA_PREBUILT="opt/eagle/bin/eagle"

RDEPEND="
	sys-libs/glibc
	|| ( virtual/jpeg:62[abi_x86_32(-)]  media-libs/jpeg:62[abi_x86_32(-)] )
	>=media-libs/libpng-1.2.51:1.2[abi_x86_32(-)]
	>=dev-libs/openssl-0.9.8z_p1-r2:0.9.8[abi_x86_32(-)]
	>=sys-libs/zlib-1.2.8-r1[abi_x86_32(-)]
	>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
	>=media-libs/fontconfig-2.10.92[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	>=x11-libs/libXrender-0.9.8[abi_x86_32(-)]
	>=x11-libs/libXrandr-1.4.2[abi_x86_32(-)]
	>=x11-libs/libXcursor-1.1.14[abi_x86_32(-)]
	>=x11-libs/libXi-1.7.2[abi_x86_32(-)]
"

# Append ${PV} since that's what upstream installs to
case "${LINGUAS}" in
	*de*)
		MY_LANG="de";;
	*)
		MY_LANG="en";;
esac

src_unpack() {
	# Extract the built-in .tar.bz2 file starting at __DATA__
	sed  -e '1,/^__DATA__$/d' "${DISTDIR}/${A}" | tar xj || die "unpacking failed"
}

src_install() {
	local installdir="/opt/eagle"

	# Set MY_LANG for this function only since UPDATE_zh and README_zh
	# don't exist
	[[ ${LINGUAS} == *zh* ]] && MY_INST_LANG="zh" || MY_INST_LANG="${MY_LANG}"

	insinto $installdir
	doins -r .

	fperms 0755 ${installdir}/bin/eagle

	# Install wrapper (suppressing leading tabs)
	# see bug #188368 or http://www.cadsoftusa.com/training/faq/#3
	exeinto /opt/bin
	newexe "${FILESDIR}/eagle_wrapper_script" eagle
	# Finally, append the path of the eagle binary respecting $installdir and any
	# arguments passed to the script (thanks Denilson)
	echo "${installdir}/bin/eagle" '"$@"' >> "${D}/opt/bin/eagle"

	# Install the documentation
	cd doc
	dodoc README_${MY_LANG} UPDATE_${MY_LANG} library_${MY_LANG}.txt
	doman eagle.1

	# Install extra documentation if requested
	if use doc; then
		dodoc {connect-device-split-symbol-${MY_INST_LANG},elektro-tutorial,manual_${MY_INST_LANG},tutorial_${MY_INST_LANG},layer-setup_designrules}.pdf
	fi
	# Remove docs left in $installdir
	rm -rf "${D}${installdir}/doc"
	cd "${S}"

	echo -e "ROOTPATH=${installdir}/bin\nPRELINK_PATH_MASK=${installdir}" > "${S}/90eagle-${PV}"
	doenvd "${S}/90eagle-${PV}"

	# Create desktop entry
	newicon bin/${PN}icon50.png ${PF}-icon50.png
	make_desktop_entry "${ROOT}/opt/bin/eagle" "CadSoft EAGLE Layout Editor" ${PF}-icon50 "Graphics;Electronics"
}

pkg_postinst() {
	elog "Run \`env-update && source /etc/profile\` from within \${ROOT}"
	elog "now to set up the correct paths."
	elog "You must first run eagle as root to invoke product registration."
	echo
	ewarn "Due to some necessary changes in the data structure, once you edit"
	ewarn "a file with version 7.x you will no longer be able to edit it"
	ewarn "with versions prior to 7.0!"
	ewarn
	ewarn "Please read /usr/share/doc/${PF}/UPDATE_${MY_LANG} if you are upgrading from 6.x/5.x/4.x."
}
