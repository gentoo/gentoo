# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD=19G
inherit check-reqs desktop unpacker xdg

DESCRIPTION="Wolfram Mathematica"
SRC_URI="
	doc? ( WLDocs_${PV}_LINUX.sh )
	Mathematica_${PV}_LINUX.sh
"
HOMEPAGE="https://www.wolfram.com/mathematica/"

LICENSE="all-rights-reserved"
KEYWORDS="-* ~amd64"
SLOT="0"
IUSE="cuda doc ffmpeg R"

RESTRICT="strip mirror bindist fetch"

# Mathematica comes with a lot of bundled stuff. We should place here only what we
# explicitly override with LD_PRELOAD.
# RLink (libjri.so) requires dev-lang/R
# FFmpegTools (FFmpegToolsSystem-5.0.so) requires media-video/ffmpeg
RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit )
	media-libs/freetype
	ffmpeg? ( media-video/ffmpeg )
	R? ( dev-lang/R )
	virtual/libcrypt
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	dev-util/patchelf
"

# we need this a few times
MPN="Mathematica"
MPV=$(ver_cut 1-2)
M_BINARIES="MathKernel Mathematica WolframKernel wolframscript math mathematica mcc wolfram"
M_TARGET="opt/Wolfram/${MPN}/${MPV}"

# we might as well list all files in all QA variables...
QA_PREBUILT="opt/*"

S=${WORKDIR}

src_unpack() {
	/bin/sh "${DISTDIR}/Mathematica_${PV}_LINUX.sh" --nox11 --keep --target "${S}/unpack_app" -- "-help" || die
	if use doc; then
		/bin/sh "${DISTDIR}/WLDocs_${PV}_LINUX.sh" --nox11 --keep --target "${S}/unpack_doc" -- "-help" || die
	fi
}

src_install() {
	local ARCH='-x86-64'

	pushd "${S}/unpack_app" > /dev/null || die
	# fix ACCESS DENIED issue when installer generate desktop files
	sed -e "s|xdg-desktop-icon|xdg-dummy-command|g" -i "Unix/Installer/MathInstaller" || die
	sed -e "s|xdg-desktop-menu|xdg-dummy-command|g" -i "Unix/Installer/MathInstaller" || die
	sed -e "s|xdg-icon-resource|xdg-dummy-command|g" -i "Unix/Installer/MathInstaller" || die
	sed -e "s|xdg-mime|xdg-dummy-command|g" -i "Unix/Installer/MathInstaller" || die
	# fix ACCESS DENIED issue when installer check the avahi-daemon
	sed -e "s|avahi-daemon -c|true|g" -i "Unix/Installer/MathInstaller" || die
	/bin/sh "Unix/Installer/MathInstaller" -auto "-targetdir=${S}/${M_TARGET}" "-execdir=${S}/opt/bin" || die
	popd > /dev/null || die

	if ! use doc; then
		einfo "Removing documentation"
		rm -r "${S}/${M_TARGET}/Documentation" || die
	else
		pushd "${S}/unpack_doc" > /dev/null || die
		/bin/sh "Unix/Installer/MathInstaller" -auto "-targetdir=${S}/temp_doc" "-execdir=${S}/opt/bin" || die
		popd > /dev/null || die
		# Merge contents of Mathematica_docs with Mathematica
		rm -r "${S}/${M_TARGET}"/Documentation/English/{SearchIndex,System} || die
		mv "${S}"/temp_doc/Documentation/English/* "${S}/${M_TARGET}/"Documentation/English/ || die
		rm -r "${S}"/temp_doc || die
	fi

	# fix world writable file QA problem for files
	while IFS= read -r -d '' i; do
		chmod o-w "${i}" || die
	done < <(find "${S}/${M_TARGET}" -type f -print0)

	einfo 'Removing MacOS- and Windows-specific files'
	find "${S}/${M_TARGET}" -type d -\( -name Windows -o -name Windows-x86-64 \
		-o -name MacOSX -o -name MacOSX-x86-64 -o -name Macintosh -\) \
		-exec rm -rv {} + || die

	if ! use cuda; then
		einfo 'Removing cuda support'
		rm -r "${S}/${M_TARGET}/SystemFiles/Components/CUDACompileTools/LibraryResources/Linux-x86-64/CUDAExtensions.so" || die
	fi

	# Linux-x86-64/AllVersions is the supported version, other versions remove
	einfo 'Removing unsupported RLink versions'
	rm -r "${S}/${M_TARGET}/SystemFiles/Links/RLink/SystemFiles/Libraries/Linux-x86-64/3.5.0" || die
	rm -r "${S}/${M_TARGET}/SystemFiles/Links/RLink/SystemFiles/Libraries/Linux-x86-64/3.6.0" || die
	rm -r "${S}/${M_TARGET}/SystemFiles/Links/RLink/SystemFiles/Libraries/Linux/AllVersions" || die
	# RLink can't use if R not used
	if ! use R; then
		einfo 'Removing RLink support'
		rm -r "${S}/${M_TARGET}/SystemFiles/Links/RLink/SystemFiles/Libraries/Linux-x86-64/AllVersions/libjri.so" || die
	fi
	# FFmpegTools can't use if ffmpeg not used
	if ! use ffmpeg || ! has_version '>=media-video/ffmpeg-5'; then
		einfo 'Removing FFmpegTools support because lack of >=media-video/ffmpeg-5'
		rm -r "${S}/${M_TARGET}/SystemFiles/Links/FFmpegTools/LibraryResources/Linux-x86-64/FFmpegToolsSystem-5.0.so" || die
	fi

	# fix RPATH
	while IFS= read -r -d '' i; do
		# Use \x7fELF header to separate ELF executables and libraries
		# Skip .o files and static files to avoid surprises
		[[ $(od -t x1 -N 4 "${i}") == *"7f 45 4c 46"* ]] || continue
		[[ -f "${i}" && "${i: -2}" != ".o" ]] || continue
		[[ "$(file "${i}")" == *"dynamically"* ]] || continue
		einfo "Fixing RPATH of ${i}"
		patchelf --set-rpath \
'/'"${M_TARGET}"'/SystemFiles/Libraries/Linux-x86-64:'\
'/'"${M_TARGET}"'/SystemFiles/Libraries/Linux-x86-64/Qt/lib:'\
'/'"${M_TARGET}"'/SystemFiles/Java/Linux-x86-64/lib:'\
'/'"${M_TARGET}"'/SystemFiles/Java/Linux-x86-64/lib/jli:'\
'$ORIGIN' "${i}" || \
		die "patchelf failed on ${i}"
	done < <(find "${S}/${M_TARGET}" -type f -print0)

	# fix broken symbolic link
	ln -sf "/${M_TARGET}/SystemFiles/Kernel/Binaries/Linux-x86-64/wolframscript" "${S}/${M_TARGET}/Executables/wolframscript" || die

	# move all over
	mv "${S}"/opt "${ED}"/opt || die

	# the autogenerated symlinks point into sandbox, remove
	rm "${ED}"/opt/bin/* || die

	# install wrappers instead
	for name in ${M_BINARIES} ; do
		einfo "Generating wrapper for ${name}"
		echo '#!/bin/sh' >> "${T}/${name}" || die
		echo 'QT_QPA_PLATFORM="wayland;xcb"' >> "${T}/${name}" || die
		echo "LD_PRELOAD=/usr/$(get_libdir)/libfreetype.so.6:/$(get_libdir)/libz.so.1:/$(get_libdir)/libcrypt.so.1 /${M_TARGET}/Executables/${name} \$*" \
			>> "${T}/${name}" || die
		dobin "${T}/${name}"
	done
	for name in ${M_BINARIES} ; do
		einfo "Symlinking ${name} to /opt/bin"
		dosym ../../usr/bin/${name} /opt/bin/${name}
	done

	# fix some embedded paths and install desktop files
	for filename in $(find "${ED}/${M_TARGET}/SystemFiles/Installation" -name "wolfram-mathematica*.desktop") ; do
		einfo "Fixing ${filename}"
		sed -e "s|${S}||g" -e 's|^\t\t||g' -i "${filename}" || die
		echo "Categories=Physics;Science;Engineering;2DGraphics;Graphics;" >> "${filename}" || die
		domenu "${filename}"
	done

	# install icons
	for iconsize in 16 32 64 128 256; do
		local iconfile="${ED}/${M_TARGET}/SystemFiles/FrontEnd/SystemResources/X/App-${iconsize}.png"
		if [ -e "${iconfile}" ]; then
			newicon -s "${iconsize}" "${iconfile}" wolfram-mathematica.png
		fi
	done

	# install mime types
	insinto /usr/share/mime/application
	for filename in $(find "${ED}/${M_TARGET}/SystemFiles/Installation" -name "application-*.xml"); do
		basefilename=$(basename "${filename}")
		mv "${filename}" "${T}/${basefilename#application-}" || die
		doins "${T}/${basefilename#application-}"
	done
}

pkg_nofetch() {
	einfo "Please place the Wolfram Mathematica installation file ${SRC_URI}"
	einfo "in your \$\{DISTDIR\}."
	einfo "Note that to actually run and use Mathematica you need a valid license."
	einfo "Wolfram provides time-limited evaluation licenses at ${HOMEPAGE}"
}
