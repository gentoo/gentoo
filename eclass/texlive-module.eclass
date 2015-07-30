# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/texlive-module.eclass,v 1.71 2015/07/30 12:59:09 aballier Exp $

# @ECLASS: texlive-module.eclass
# @MAINTAINER:
# tex@gentoo.org
# @AUTHOR:
# Original Author: Alexis Ballier <aballier@gentoo.org>
# @BLURB: Provide generic install functions so that modular texlive's texmf ebuild will only have to inherit this eclass
# @DESCRIPTION:
# Purpose: Provide generic install functions so that modular texlive's texmf ebuilds will
# only have to inherit this eclass.
# Ebuilds have to provide TEXLIVE_MODULE_CONTENTS variable that contains the list
# of packages that it will install. (See below)
#
# For TeX Live versions prior to 2009, the ebuild was supposed to unpack the
# texmf and texmf-dist directories to ${WORKDIR} (which is what the default
# src_unpack does).
# Starting from TeX Live 2009, the eclass provides a src_unpack function taking
# care of unpacking and relocating the files that need it.
#
# It inherits texlive-common.  Patching is supported via the PATCHES
# bash array.

# @ECLASS-VARIABLE: TEXLIVE_MODULE_CONTENTS
# @DESCRIPTION:
# The list of packages that will be installed. This variable will be expanded to
# SRC_URI:
# foo -> texlive-module-foo-${PV}.tar.xz

# @ECLASS-VARIABLE: TEXLIVE_MODULE_DOC_CONTENTS
# @DESCRIPTION:
# The list of packages that will be installed if the doc useflag is enabled.
# Expansion to SRC_URI is the same as for TEXLIVE_MODULE_CONTENTS.

# @ECLASS-VARIABLE: TEXLIVE_MODULE_SRC_CONTENTS
# @DESCRIPTION:
# The list of packages that will be installed if the source useflag is enabled.
# Expansion to SRC_URI is the same as for TEXLIVE_MODULE_CONTENTS.

# @ECLASS-VARIABLE: TEXLIVE_MODULE_BINSCRIPTS
# @DESCRIPTION:
# A space separated list of files that are in fact scripts installed in the
# texmf tree and that we want to be available directly. They will be installed in
# /usr/bin.

# @ECLASS-VARIABLE: TEXLIVE_MODULE_BINLINKS
# @DESCRIPTION:
# A space separated list of links to add for BINSCRIPTS.
# The systax is: foo:bar to create a symlink bar -> foo.

# @ECLASS-VARIABLE: TL_PV
# @DESCRIPTION:
# Normally the module's PV reflects the TeXLive release it belongs to.
# If this is not the case, TL_PV takes the version number for the
# needed app-text/texlive-core.

# @ECLASS-VARIABLE: TL_MODULE_INFORMATION
# @DESCRIPTION:
# Information to display about the package.
# e.g. for enabling/disabling a feature

# @ECLASS-VARIABLE: PATCHES
# @DESCRIPTION:
# Array variable specifying any patches to be applied.

inherit texlive-common eutils

case "${EAPI:-0}" in
	0|1|2)
		die "EAPI='${EAPI}' is not supported anymore"
		;;
	*)
		;;
esac

HOMEPAGE="http://www.tug.org/texlive/"

COMMON_DEPEND=">=app-text/texlive-core-${TL_PV:-${PV}}"

IUSE="source"

# Starting from TeX Live 2009, upstream provides .tar.xz modules.
PKGEXT=tar.xz
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils"

for i in ${TEXLIVE_MODULE_CONTENTS}; do
	SRC_URI="${SRC_URI} mirror://gentoo/texlive-module-${i}-${PV}.${PKGEXT}"
done

# Forge doc SRC_URI
[ -n "${PN##*documentation*}" ] && [ -n "${TEXLIVE_MODULE_DOC_CONTENTS}" ] && SRC_URI="${SRC_URI} doc? ("
for i in ${TEXLIVE_MODULE_DOC_CONTENTS}; do
	SRC_URI="${SRC_URI} mirror://gentoo/texlive-module-${i}-${PV}.${PKGEXT}"
done
[ -n "${PN##*documentation*}" ] && [ -n "${TEXLIVE_MODULE_DOC_CONTENTS}" ] && SRC_URI="${SRC_URI} )"

# Forge source SRC_URI
if [ -n "${TEXLIVE_MODULE_SRC_CONTENTS}" ] ; then
	SRC_URI="${SRC_URI} source? ("
	for i in ${TEXLIVE_MODULE_SRC_CONTENTS}; do
		SRC_URI="${SRC_URI} mirror://gentoo/texlive-module-${i}-${PV}.${PKGEXT}"
	done
	SRC_URI="${SRC_URI} )"
fi

RDEPEND="${COMMON_DEPEND}"

[ -z "${PN##*documentation*}" ] || IUSE="${IUSE} doc"

# @ECLASS-VARIABLE: TEXLIVE_MODULE_OPTIONAL_ENGINE
# @DESCRIPTION:
# A space separated list of Tex engines that can be made optional.
# e.g. "luatex luajittex"

if [ -n "${TEXLIVE_MODULE_OPTIONAL_ENGINE}" ] ; then
	for engine in ${TEXLIVE_MODULE_OPTIONAL_ENGINE} ; do
		IUSE="${IUSE} +${engine}"
	done
fi

S="${WORKDIR}"

# @FUNCTION: texlive-module_src_unpack
# @DESCRIPTION:
# Only for TeX Live 2009 and later.
# After unpacking, the files that need to be relocated are moved accordingly.

RELOC_TARGET=texmf-dist

texlive-module_src_unpack() {
	unpack ${A}

	grep RELOC tlpkg/tlpobj/* | awk '{print $2}' | sed 's#^RELOC/##' > "${T}/reloclist"
	{ for i in $(<"${T}/reloclist"); do  dirname $i; done; } | uniq > "${T}/dirlist"
	for i in $(<"${T}/dirlist"); do
		[ -d "${RELOC_TARGET}/${i}" ] || mkdir -p "${RELOC_TARGET}/${i}"
	done
	for i in $(<"${T}/reloclist"); do
		mv "${i}" "${RELOC_TARGET}"/$(dirname "${i}") || die "failed to relocate ${i} to ${RELOC_TARGET}/$(dirname ${i})"
	done
}

# @FUNCTION: texlive-module_src_prepare
# @DESCRIPTION:
# Apply patches from the PATCHES array and user patches, if any.

texlive-module_src_prepare() {
	[[ ${#PATCHES[@]} -gt 0 ]] && epatch "${PATCHES[@]}"
	epatch_user
}

# @FUNCTION: texlive-module_add_format
# @DESCRIPTION:
# Creates/appends to a format.${PN}.cnf file for fmtutil.
# It parses the AddFormat directive of tlpobj files to create it.
# This will make fmtutil generate the formats when asked and allow the remaining
# src_compile phase to build the formats.

texlive-module_add_format() {
	local name engine mode patterns options
	eval $@
	einfo "Appending to format.${PN}.cnf for $@"
	[ -d texmf-dist/fmtutil ] || mkdir -p texmf-dist/fmtutil
	[ -f texmf-dist/fmtutil/format.${PN}.cnf ] || { echo "# Generated for ${PN}	by texlive-module.eclass" > texmf-dist/fmtutil/format.${PN}.cnf; }
	[ -n "${TEXLIVE_MODULE_OPTIONAL_ENGINE}" ] && has ${engine} ${TEXLIVE_MODULE_OPTIONAL_ENGINE} && use !${engine} && mode="disabled"
	if [ "${mode}" = "disabled" ]; then
		printf "#! " >> texmf-dist/fmtutil/format.${PN}.cnf
	fi
	[ -z "${patterns}" ] && patterns="-"
	printf "${name}\t${engine}\t${patterns}\t${options}\n" >> texmf-dist/fmtutil/format.${PN}.cnf
}

# @FUNCTION: texlive-module_make_language_def_lines
# @DESCRIPTION:
# Creates a language.${PN}.def entry to put in /etc/texmf/language.def.d.
# It parses the AddHyphen directive of tlpobj files to create it.

texlive-module_make_language_def_lines() {
	local lefthyphenmin righthyphenmin synonyms name file file_patterns file_exceptions luaspecial
	eval $@
	einfo "Generating language.def entry for $@"
	[ -z "$lefthyphenmin" ] && lefthyphenmin="2"
	[ -z "$righthyphenmin" ] && righthyphenmin="3"
	echo "\\addlanguage{$name}{$file}{}{$lefthyphenmin}{$righthyphenmin}" >> "${S}/language.${PN}.def"
	if [ -n "$synonyms" ] ; then
		for i in $(echo $synonyms | tr ',' ' ') ; do
			einfo "Generating language.def synonym $i for $@"
			echo "\\addlanguage{$i}{$file}{}{$lefthyphenmin}{$righthyphenmin}" >> "${S}/language.${PN}.def"
		done
	fi
}

# @FUNCTION: texlive-module_make_language_dat_lines
# @DESCRIPTION:
# Creates a language.${PN}.dat entry to put in /etc/texmf/language.dat.d.
# It parses the AddHyphen directive of tlpobj files to create it.

texlive-module_make_language_dat_lines() {
	local lefthyphenmin righthyphenmin synonyms name file file_patterns file_exceptions luaspecial
	eval $@
	einfo "Generating language.dat entry for $@"
	echo "$name $file" >> "${S}/language.${PN}.dat"
	if [ -n "$synonyms" ] ; then
		for i in $(echo $synonyms | tr ',' ' ') ; do
			einfo "Generating language.dat synonym $i for $@"
			echo "=$i" >> "${S}/language.${PN}.dat"
		done
	fi
}

# @FUNCTION: texlive-module_synonyms_to_language_lua_line
# @DESCRIPTION:
# Helper function for texlive-module_make_language_lua_lines to generate a
# correctly formatted synonyms entry for language.dat.lua.

texlive-module_synonyms_to_language_lua_line() {
	local prev=""
	for i in $(echo $@ | tr ',' ' ') ; do
		printf "${prev} '%s'" $i
		prev=","
	done
}

# @FUNCTION: texlive-module_make_language_lua_lines
# @DESCRIPTION:
# Only valid for TeXLive 2010 and later.
# Creates a language.${PN}.dat.lua entry to put in
# /etc/texmf/language.dat.lua.d.
# It parses the AddHyphen directive of tlpobj files to create it.

texlive-module_make_language_lua_lines() {
	local lefthyphenmin righthyphenmin synonyms name file file_patterns file_exceptions luaspecial
	local dest="${S}/language.${PN}.dat.lua"
	eval $@
	[ -z "$lefthyphenmin"  ] && lefthyphenmin="2"
	[ -z "$righthyphenmin" ] && righthyphenmin="3"
	einfo "Generating language.dat.lua entry for $@"
	printf "\t['%s'] = {\n" "$name"                                                                 >> "$dest"
	printf "\t\tloader = '%s',\n" "$file"                                                           >> "$dest"
	printf "\t\tlefthyphenmin = %s,\n\t\trighthyphenmin = %s,\n" "$lefthyphenmin" "$righthyphenmin" >> "$dest"
	printf "\t\tsynonyms = {%s },\n" "$(texlive-module_synonyms_to_language_lua_line "$synonyms")"  >> "$dest"
	[ -n "$file_patterns"   ] && printf "\t\tpatterns = '%s',\n" "$file_patterns"                   >> "$dest"
	[ -n "$file_exceptions" ] && printf "\t\thyphenation = '%s',\n"	"$file_exceptions"              >> "$dest"
	[ -n "$luaspecial"      ] && printf "\t\tspecial = '%s',\n" "$luaspecial"                       >> "$dest"
	printf "\t},\n"                                                                                 >> "$dest"
}

# @FUNCTION: texlive-module_src_compile
# @DESCRIPTION:
# exported function:
# Generates the config files that are to be installed in /etc/texmf;
# texmf-update script will take care of merging the different config files for
# different packages in a single one used by the whole tex installation.
#
# Once the config files are generated, we build the format files using fmtutil
# (provided by texlive-core). The compiled format files will be sent to
# texmf-var/web2c, like fmtutil defaults to but with some trick to stay in the
# sandbox.

texlive-module_src_compile() {
	# Generate config files from the tlpobj files provided by TeX Live 2008 and
	# later
	for i in "${S}"/tlpkg/tlpobj/*;
	do
		grep '^execute ' "${i}" | sed -e 's/^execute //' | tr ' \t' '##' |sort|uniq >> "${T}/jobs"
	done

	for i in $(<"${T}/jobs");
	do
		j="$(echo $i | tr '#' ' ')"
		command=${j%% *}
		parameter=${j#* }
		case "${command}" in
			addMap)
				echo "Map ${parameter}" >> "${S}/${PN}.cfg";;
			addMixedMap)
				echo "MixedMap ${parameter}" >> "${S}/${PN}.cfg";;
			addKanjiMap)
				echo "KanjiMap ${parameter}" >> "${S}/${PN}.cfg";;
			addDvipsMap)
				echo "p	+${parameter}" >> "${S}/${PN}-config.ps";;
			addDvipdfmMap)
				echo "f	${parameter}" >> "${S}/${PN}-config";;
			AddHyphen)
				texlive-module_make_language_def_lines "$parameter"
				texlive-module_make_language_dat_lines "$parameter"
				texlive-module_make_language_lua_lines "$parameter"
				;;
			AddFormat)
				texlive-module_add_format "$parameter";;
			BuildFormat)
				einfo "Format $parameter already built.";;
			BuildLanguageDat)
				einfo "Language file $parameter already generated.";;
			*)
				die "No rule to proccess ${command}. Please file a bug."
		esac
	done

	# Build format files
	for i in texmf-dist/fmtutil/format*.cnf; do
		if [ -f "${i}" ]; then
			einfo "Building format ${i}"
			[ -d texmf-var ] || mkdir texmf-var
			[ -d texmf-var/web2c ] || mkdir texmf-var/web2c
			VARTEXFONTS="${T}/fonts" TEXMFHOME="${S}/texmf:${S}/texmf-dist:${S}/texmf-var"\
				env -u TEXINPUTS fmtutil --cnffile "${i}" --fmtdir "${S}/texmf-var/web2c" --all\
				|| die "failed to build format ${i}"
		fi
	done

	# Delete ls-R files, these should not be created but better be certain they
	# do not end up being installed.
	find . -name 'ls-R' -delete
}

# @FUNCTION: texlive-module_src_install
# @DESCRIPTION:
# exported function:
# Installs texmf and config files to the system.

texlive-module_src_install() {
	for i in texmf-dist/fmtutil/format*.cnf; do
		[ -f "${i}" ] && etexlinks "${i}"
	done

	dodir /usr/share
	if [ -z "${PN##*documentation*}" ] || use doc; then
		[ -d texmf-doc ] && cp -pR texmf-doc "${ED}/usr/share/"
	else
		[ -d texmf/doc ] && rm -rf texmf/doc
		[ -d texmf-dist/doc ] && rm -rf texmf-dist/doc
	fi

	[ -d texmf ] && cp -pR texmf "${ED}/usr/share/"
	[ -d texmf-dist ] && cp -pR texmf-dist "${ED}/usr/share/"
	[ -d tlpkg ] && use source && cp -pR tlpkg "${ED}/usr/share/"

	insinto /var/lib/texmf
	[ -d texmf-var ] && doins -r texmf-var/*

	insinto /etc/texmf/updmap.d
	[ -f "${S}/${PN}.cfg" ] && doins "${S}/${PN}.cfg"
	insinto /etc/texmf/dvips.d
	[ -f "${S}/${PN}-config.ps" ] && doins "${S}/${PN}-config.ps"
	insinto /etc/texmf/dvipdfm/config
	[ -f "${S}/${PN}-config" ] && doins "${S}/${PN}-config"

	if [ -f "${S}/language.${PN}.def" ] ; then
		insinto /etc/texmf/language.def.d
		doins "${S}/language.${PN}.def"
	fi

	if [ -f "${S}/language.${PN}.dat" ] ; then
		insinto /etc/texmf/language.dat.d
		doins "${S}/language.${PN}.dat"
	fi

	if [ -f "${S}/language.${PN}.dat.lua" ] ; then
		insinto /etc/texmf/language.dat.lua.d
		doins "${S}/language.${PN}.dat.lua"
	fi

	[ -n "${TEXLIVE_MODULE_BINSCRIPTS}" ] && dobin_texmf_scripts ${TEXLIVE_MODULE_BINSCRIPTS}
	if [ -n "${TEXLIVE_MODULE_BINLINKS}" ] ; then
		for i in ${TEXLIVE_MODULE_BINLINKS} ; do
			[ -f "${ED}/usr/bin/${i%:*}" ] || die "Trying to install an invalid	BINLINK. This should not happen. Please file a bug."
			dosym ${i%:*} /usr/bin/${i#*:}
		done
	fi

	texlive-common_handle_config_files
	TEXMF_PATH=${TEXMF_DIST_PATH} texlive-common_handle_config_files
}

# @FUNCTION: texlive-module_pkg_postinst
# @DESCRIPTION:
# exported function:
# Run texmf-update to ensure the tex installation is consistent with the
# installed texmf trees.

texlive-module_pkg_postinst() {
	etexmf-update
	[ -n "${TL_MODULE_INFORMATION}" ] && elog "${TL_MODULE_INFORMATION}"
}

# @FUNCTION: texlive-module_pkg_postrm
# @DESCRIPTION:
# exported function:
# Run texmf-update to ensure the tex installation is consistent with the
# installed texmf trees.

texlive-module_pkg_postrm() {
	etexmf-update
}

EXPORT_FUNCTIONS src_unpack src_prepare src_compile src_install \
	pkg_postinst pkg_postrm
