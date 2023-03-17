# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: texlive-module.eclass
# @MAINTAINER:
# tex@gentoo.org
# @AUTHOR:
# Original Author: Alexis Ballier <aballier@gentoo.org>
# @SUPPORTED_EAPIS: 7
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

# @ECLASS_VARIABLE: TEXLIVE_MODULE_CONTENTS
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# The list of packages that will be installed. This variable will be expanded to
# SRC_URI:
# foo -> texlive-module-foo-${PV}.tar.xz

# @ECLASS_VARIABLE: TEXLIVE_MODULE_DOC_CONTENTS
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# The list of packages that will be installed if the doc useflag is enabled.
# Expansion to SRC_URI is the same as for TEXLIVE_MODULE_CONTENTS.

# @ECLASS_VARIABLE: TEXLIVE_MODULE_SRC_CONTENTS
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# The list of packages that will be installed if the source useflag is enabled.
# Expansion to SRC_URI is the same as for TEXLIVE_MODULE_CONTENTS.

# @ECLASS_VARIABLE: TEXLIVE_MODULE_BINSCRIPTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# A space separated list of files that are in fact scripts installed in the
# texmf tree and that we want to be available directly. They will be installed in
# /usr/bin.

# @ECLASS_VARIABLE: TEXLIVE_MODULE_BINLINKS
# @DEFAULT_UNSET
# @DESCRIPTION:
# A space separated list of links to add for BINSCRIPTS.
# The systax is: foo:bar to create a symlink bar -> foo.

# @ECLASS_VARIABLE: TL_PV
# @INTERNAL
# @DESCRIPTION:
# Normally the module's PV reflects the TeXLive release it belongs to.
# If this is not the case, TL_PV takes the version number for the
# needed app-text/texlive-core.

# @ECLASS_VARIABLE: TL_MODULE_INFORMATION
# @DEFAULT_UNSET
# @DESCRIPTION:
# Information to display about the package.
# e.g. for enabling/disabling a feature

case ${EAPI} in
	7) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_TEXLIVE_MODULE_ECLASS} ]]; then
_TEXLIVE_MODULE_ECLASS=1

inherit texlive-common

HOMEPAGE="http://www.tug.org/texlive/"

COMMON_DEPEND=">=app-text/texlive-core-${TL_PV:-${PV}}"

IUSE="source"

# Starting from TeX Live 2009, upstream provides .tar.xz modules.
PKGEXT=tar.xz

# Now where should we get these files?
TEXLIVE_DEVS=${TEXLIVE_DEVS:- zlogene dilfridge }

# We do not need anything from SYSROOT:
#   Everything is built from the texlive install in /
#   Generated files are noarch
BDEPEND="${COMMON_DEPEND}
	app-arch/xz-utils"

for i in ${TEXLIVE_MODULE_CONTENTS}; do
	for tldev in ${TEXLIVE_DEVS}; do
		SRC_URI="${SRC_URI} https://dev.gentoo.org/~${tldev}/distfiles/texlive/tl-${i}-${PV}.${PKGEXT}"
	done
done

# Forge doc SRC_URI
[[ -n ${TEXLIVE_MODULE_DOC_CONTENTS} ]] && SRC_URI="${SRC_URI} doc? ("
for i in ${TEXLIVE_MODULE_DOC_CONTENTS}; do
	for tldev in ${TEXLIVE_DEVS}; do
		SRC_URI="${SRC_URI} https://dev.gentoo.org/~${tldev}/distfiles/texlive/tl-${i}-${PV}.${PKGEXT}"
	done
done
[[ -n ${TEXLIVE_MODULE_DOC_CONTENTS} ]] && SRC_URI="${SRC_URI} )"

# Forge source SRC_URI
if [[ -n ${TEXLIVE_MODULE_SRC_CONTENTS} ]] ; then
	SRC_URI="${SRC_URI} source? ("
	for i in ${TEXLIVE_MODULE_SRC_CONTENTS}; do
		for tldev in ${TEXLIVE_DEVS}; do
			SRC_URI="${SRC_URI} https://dev.gentoo.org/~${tldev}/distfiles/texlive/tl-${i}-${PV}.${PKGEXT}"
		done
	done
	SRC_URI="${SRC_URI} )"
fi

RDEPEND="${COMMON_DEPEND}"

IUSE="${IUSE} doc"

# @ECLASS_VARIABLE: TEXLIVE_MODULE_OPTIONAL_ENGINE
# @DEFAULT_UNSET
# @DESCRIPTION:
# A space separated list of Tex engines that can be made optional.
# e.g. "luatex luajittex"

if [[ -n ${TEXLIVE_MODULE_OPTIONAL_ENGINE} ]] ; then
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

	sed -n -e 's:\s*RELOC/::p' tlpkg/tlpobj/* > "${T}/reloclist" || die
	sed -e 's/\/[^/]*$//' -e "s:^:${RELOC_TARGET}/:" "${T}/reloclist" |
		sort -u |
		xargs mkdir -p || die
	local i
	while read i; do
		mv "${i}" "${RELOC_TARGET}/${i%/*}" || die
	done < "${T}/reloclist"
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

	if [[ ! -d texmf-dist/fmtutil ]]; then
		mkdir -p texmf-dist/fmtutil || die
	fi

	[[ -f texmf-dist/fmtutil/format.${PN}.cnf ]] || { echo "# Generated for ${PN}	by texlive-module.eclass" > texmf-dist/fmtutil/format.${PN}.cnf; }
	[[ -n ${TEXLIVE_MODULE_OPTIONAL_ENGINE} ]] && has ${engine} ${TEXLIVE_MODULE_OPTIONAL_ENGINE} && use !${engine} && mode="disabled"
	if [[ ${mode} = disabled ]]; then
		printf "#! " >> texmf-dist/fmtutil/format.${PN}.cnf || die
	fi
	[[ -z ${patterns} ]] && patterns="-"
	printf "${name}\t${engine}\t${patterns}\t${options}\n" >> texmf-dist/fmtutil/format.${PN}.cnf || die
}

# @FUNCTION: texlive-module_make_language_def_lines
# @DESCRIPTION:
# Creates a language.${PN}.def entry to put in /etc/texmf/language.def.d.
# It parses the AddHyphen directive of tlpobj files to create it.

texlive-module_make_language_def_lines() {
	local lefthyphenmin righthyphenmin synonyms name file file_patterns file_exceptions luaspecial
	eval $@
	einfo "Generating language.def entry for $@"
	[[ -z ${lefthyphenmin} ]] && lefthyphenmin="2"
	[[ -z ${righthyphenmin} ]] && righthyphenmin="3"
	echo "\\addlanguage{$name}{$file}{}{$lefthyphenmin}{$righthyphenmin}" >> "${S}/language.${PN}.def" || die
	if [[ -n ${synonyms} ]]; then
		for i in $(echo $synonyms | tr ',' ' ') ; do
			einfo "Generating language.def synonym $i for $@"
			echo "\\addlanguage{$i}{$file}{}{$lefthyphenmin}{$righthyphenmin}" >> "${S}/language.${PN}.def" || die
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
	echo "$name $file" >> "${S}/language.${PN}.dat" || die
	if [[ -n ${synonyms} ]]; then
		for i in $(echo ${synonyms} | tr ',' ' ') ; do
			einfo "Generating language.dat synonym ${i} for $@"
			echo "=${i}" >> "${S}/language.${PN}.dat" || die
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
		printf "${prev} '%s'" ${i}
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
	[[ -z ${lefthyphenmin}  ]] && lefthyphenmin="2"
	[[ -z ${righthyphenmin} ]] && righthyphenmin="3"
	einfo "Generating language.dat.lua entry for $@"
	printf "\t['%s'] = {\n" "${name}"                                                                   >> "${dest}" || die
	printf "\t\tloader = '%s',\n" "${file}"                                                             >> "${dest}" || die
	printf "\t\tlefthyphenmin = %s,\n\t\trighthyphenmin = %s,\n" "${lefthyphenmin}" "${righthyphenmin}" >> "${dest}" || die
	printf "\t\tsynonyms = {%s },\n" "$(texlive-module_synonyms_to_language_lua_line "${synonyms}")"    >> "${dest}" || die

	if [[ -n ${file_patterns} ]]; then
		printf "\t\tpatterns = '%s',\n" "${file_patterns}"                   >> "${dest}" || die
	fi

	if [[ -n ${file_exceptions} ]]; then
		printf "\t\thyphenation = '%s',\n"	"${file_exceptions}"          >> "${dest}" || die
	fi

	if [[ -n ${luaspecial} ]]; then
		printf "\t\tspecial = '%s',\n" "$luaspecial"                          >> "${dest}" || die
	fi

	printf "\t},\n"                                                                >> "${dest}" || die
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
		grep '^execute ' "${i}" | sed -e 's/^execute //' | tr ' \t' '##' >> "${T}/jobs" || die
	done

	for i in $(<"${T}/jobs");
	do
		j="$(echo $i | tr '#' ' ')"
		command=${j%% *}
		parameter=${j#* }
		case ${command} in
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
				texlive-module_make_language_def_lines ${parameter}
				texlive-module_make_language_dat_lines ${parameter}
				texlive-module_make_language_lua_lines ${parameter}
				;;
			AddFormat)
				texlive-module_add_format ${parameter};;
			BuildFormat)
				einfo "Format ${parameter} already built.";;
			BuildLanguageDat)
				einfo "Language file $parameter already generated.";;
			*)
				die "No rule to proccess ${command}. Please file a bug."
		esac
	done

	# Determine texlive-core version for fmtutil call
        fmt_call="$(has_version '>=app-text/texlive-core-2019' \
         && echo "fmtutil-user" || echo "fmtutil")"

	# Build format files
	for i in texmf-dist/fmtutil/format*.cnf; do
		if [[ -f ${i} ]]; then
			einfo "Building format ${i}"
			if [[ ! -d texmf-var ]]; then
				mkdir texmf-var || die
			fi
			if [[ ! -d texmf-var/web2c ]]; then
				mkdir texmf-var/web2c || die
			fi
			VARTEXFONTS="${T}/fonts" TEXMFHOME="${S}/texmf:${S}/texmf-dist:${S}/texmf-var"\
				env -u TEXINPUTS $fmt_call --cnffile "${i}" --fmtdir "${S}/texmf-var/web2c" --all\
				|| die "failed to build format ${i}"
		fi
	done

	# Delete ls-R files, these should not be created but better be certain they
	# do not end up being installed.
	find . -name 'ls-R' -delete || die
}

# @FUNCTION: texlive-module_src_install
# @DESCRIPTION:
# exported function:
# Installs texmf and config files to the system.

texlive-module_src_install() {
	for i in texmf-dist/fmtutil/format*.cnf; do
		[[ -f ${i} ]] && etexlinks "${i}"
	done

	dodir /usr/share
	if use doc; then
		if [[ -d texmf-doc ]]; then
			cp -pR texmf-doc "${ED}/usr/share/" || die
		fi
	else
		if [[ -d texmf-dist/doc ]]; then
			rm -rf texmf-dist/doc || die
		fi

		if [[ -d texmf/doc ]]; then
			rm -rf texmf/doc || die
		fi
	fi

	if [[ -d texmf ]]; then
		cp -pR texmf "${ED}/usr/share/" || die
	fi

	if [[ -d texmf-dist ]]; then
		cp -pR texmf-dist "${ED}/usr/share/" || die
	fi

	if [[ -d tlpkg ]] && use source; then
		cp -pR tlpkg "${ED}/usr/share/" || die
	fi


	if [[ -d texmf-var ]]; then
		insinto /var/lib/texmf
		doins -r texmf-var/.
	fi

	insinto /etc/texmf/updmap.d
	[[ -f ${S}/${PN}.cfg ]] && doins "${S}/${PN}.cfg"
	insinto /etc/texmf/dvips.d
	[[ -f ${S}/${PN}-config.ps ]] && doins "${S}/${PN}-config.ps"
	insinto /etc/texmf/dvipdfm/config
	[[ -f ${S}/${PN}-config ]] && doins "${S}/${PN}-config"

	if [[ -f ${S}/language.${PN}.def ]] ; then
		insinto /etc/texmf/language.def.d
		doins "${S}/language.${PN}.def"
	fi

	if [[ -f ${S}/language.${PN}.dat ]] ; then
		insinto /etc/texmf/language.dat.d
		doins "${S}/language.${PN}.dat"
	fi

	if [[ -f ${S}/language.${PN}.dat.lua ]] ; then
		insinto /etc/texmf/language.dat.lua.d
		doins "${S}/language.${PN}.dat.lua"
	fi

	[[ -n ${TEXLIVE_MODULE_BINSCRIPTS} ]] && dobin_texmf_scripts ${TEXLIVE_MODULE_BINSCRIPTS}
	if [[ -n ${TEXLIVE_MODULE_BINLINKS} ]] ; then
		for i in ${TEXLIVE_MODULE_BINLINKS} ; do
			[[ -f ${ED}/usr/bin/${i%:*} ]] || die "Trying to install an invalid	BINLINK. This should not happen. Please file a bug."
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
	[[ -n ${TL_MODULE_INFORMATION} ]] && elog "${TL_MODULE_INFORMATION}"
}

# @FUNCTION: texlive-module_pkg_postrm
# @DESCRIPTION:
# exported function:
# Run texmf-update to ensure the tex installation is consistent with the
# installed texmf trees.

texlive-module_pkg_postrm() {
	etexmf-update
}

fi

EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst pkg_postrm
