# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/eagle/eagle-7.3.0.ebuild,v 1.1 2015/07/11 22:20:49 idl0r Exp $

EAPI="5"

inherit eutils

DESCRIPTION="CadSoft EAGLE schematic and printed circuit board (PCB) layout editor"
HOMEPAGE="http://www.cadsoft.de"
SRC_URI="
	x86? ( ftp://ftp.cadsoft.de/${PN}/program/${PV%\.[0-9]}/${PN}-lin32-${PV}.run )
	amd64? ( ftp://ftp.cadsoft.de/${PN}/program/${PV%\.[0-9]}/${PN}-lin64-${PV}.run )"

LICENSE="cadsoft-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE="doc linguas_de linguas_zh"

QA_PREBUILT="opt/eagle/bin/eagle"
RESTRICT="mirror bindist"

RDEPEND="
	sys-libs/glibc
	dev-libs/openssl:0
	>=sys-libs/zlib-1.2.8-r1
	>=media-libs/freetype-2.5.0.1
	>=media-libs/fontconfig-2.10.92
	x11-libs/libXext
	x11-libs/libX11
	>=x11-libs/libXrender-0.9.8
	>=x11-libs/libXrandr-1.4.2
	>=x11-libs/libXcursor-1.1.14
	>=x11-libs/libXi-1.7.2
	net-print/cups
	x11-libs/libxcb
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

	# Install the documentation
	cd doc/

	local pattern="^((README|UPDATE)_${MY_LANG}|library_${MY_LANG}\.txt)$"
	for docs in README_* UPDATE_* library_*.txt; do
		if [[ $docs =~ $pattern ]]; then
			dodoc $docs
		fi

		rm -f $docs
	done

	doman eagle.1
	rm eagle.1

	# Install extra documentation if requested
	pattern="^((tutorial|manual|generate-3d-idf-data)_|(connect-device-split-symbol|make-symbol-device-package-bsdl-2011)-)${MY_LANG}.pdf$"
	if use doc; then
		cd ulp/
			for docs in generate-3d-idf-data_*.pdf connect-device-split-symbol-*.pdf make-symbol-device-package-bsdl-2011-*.pdf; do
				if [[ ! $docs =~ $pattern ]]; then
					rm $docs
				fi
			done
		cd ../

		for docs in manual_* tutorial_*; do
			if [[ ! $docs =~ $pattern ]]; then
				rm $docs
			fi
		done
	else
		rm {elektro-tutorial,manual_*,tutorial_*,layer-setup_designrules}.pdf
		rm -rf ulp/
	fi

	rm -f license*.txt eagle.dtd

	cd "${S}"

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
	ewarn "Please read /usr/share/doc/${PF}/UPDATE_${MY_LANG} if you are upgrading from a version prior 7.x!"
}
