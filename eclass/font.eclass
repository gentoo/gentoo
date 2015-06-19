# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/font.eclass,v 1.58 2015/02/21 07:20:22 yngwin Exp $

# @ECLASS: font.eclass
# @MAINTAINER:
# fonts@gentoo.org
# @BLURB: Eclass to make font installation uniform

inherit eutils

EXPORT_FUNCTIONS pkg_setup src_install pkg_postinst pkg_postrm

# @ECLASS-VARIABLE: FONT_SUFFIX
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# Space delimited list of font suffixes to install.
FONT_SUFFIX=${FONT_SUFFIX:-}

# @ECLASS-VARIABLE: FONT_S
# @REQUIRED
# @DESCRIPTION:
# Space delimited list of directories containing the fonts.
FONT_S=${FONT_S:-${S}}

# @ECLASS-VARIABLE: FONT_PN
# @DESCRIPTION:
# Font name (ie. last part of FONTDIR).
FONT_PN=${FONT_PN:-${PN}}

# @ECLASS-VARIABLE: FONTDIR
# @DESCRIPTION:
# Full path to installation directory.
FONTDIR=${FONTDIR:-/usr/share/fonts/${FONT_PN}}

# @ECLASS-VARIABLE: FONT_CONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing fontconfig conf files to install.
FONT_CONF=( "" )

# @ECLASS-VARIABLE: DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Space delimited list of docs to install.
# We always install these:
# COPYRIGHT README{,.txt} NEWS AUTHORS BUGS ChangeLog FONTLOG.txt
DOCS=${DOCS:-}

IUSE="X"

DEPEND="X? (
		x11-apps/mkfontdir
		media-fonts/encodings
	)"
RDEPEND=""

# @FUNCTION: font_xfont_config
# @DESCRIPTION:
# Generate Xorg font files (mkfontscale/mkfontdir).
font_xfont_config() {
	local dir_name
	if has X ${IUSE//+} && use X ; then
		dir_name="${1:-${FONT_PN}}"
		ebegin "Creating fonts.scale & fonts.dir in ${dir_name##*/}"
		rm -f "${ED}${FONTDIR}/${1//${S}/}"/{fonts.{dir,scale},encodings.dir}
		mkfontscale "${ED}${FONTDIR}/${1//${S}/}"
		mkfontdir \
			-e ${EPREFIX}/usr/share/fonts/encodings \
			-e ${EPREFIX}/usr/share/fonts/encodings/large \
			"${ED}${FONTDIR}/${1//${S}/}"
		eend $?
		if [[ -e fonts.alias ]] ; then
			doins fonts.alias
		fi
	fi
}

# @FUNCTION: font_fontconfig
# @DESCRIPTION:
# Install fontconfig conf files given in FONT_CONF.
font_fontconfig() {
	local conffile
	if [[ -n ${FONT_CONF[@]} ]]; then
		insinto /etc/fonts/conf.avail/
		for conffile in "${FONT_CONF[@]}"; do
			[[ -e  ${conffile} ]] && doins ${conffile}
		done
	fi
}

# @FUNCTION: font_cleanup_dirs
# @DESCRIPTION:
# Remove font directories containing only generated files.
font_cleanup_dirs() {
	local genfiles="encodings.dir fonts.alias fonts.cache-1 fonts.dir fonts.scale"
	# fonts.alias isn't generated but it's a special case (see below).
	local d f g generated candidate otherfile

	ebegin "Cleaning up font directories"
	find -L "${EROOT}"usr/share/fonts/ -type d -print0 | while read -d $'\0' d; do
		candidate=false
		otherfile=false
		for f in "${d}"/*; do
			generated=false
			# make sure this is a file and not a subdir
			[[ -e ${f} || -L ${f} ]] || continue
			for g in ${genfiles}; do
				if [[ ${f##*/} == ${g} ]]; then
					# this is a generated file
					generated=true
					break
				fi
			done
			# if the file is a generated file then we know this is a font dir (as
			# opposed to something like encodings or util) and a candidate for
			# removal.  if it's not generated then it's an "otherfile".
			${generated} && candidate=true || otherfile=true
			# if the directory is both a candidate for removal and contains at
			# least one "otherfile" then don't remove it.
			[[ ${candidate} == ${otherfile} ]] && break
		done
		# if in the end we only have generated files, purge the directory.
		if [[ ${candidate} == true && ${otherfile} == false ]]; then
			# we don't want to remove fonts.alias files that were installed by
			# media-fonts/font-alias. any other fonts.alias files will have
			# already been unmerged with their packages.
			for g in ${genfiles}; do
				[[ ${g} != fonts.alias && ( -e ${d}/${g} || -L ${d}/${g} ) ]] \
					&& rm "${d}"/${g}
			done
			# if there's nothing left remove the directory
			find "${d}" -maxdepth 0 -type d -empty -exec rmdir '{}' \;
		fi
	done
	eend 0
}

# @FUNCTION: font_pkg_setup
# @DESCRIPTION:
# The font pkg_setup function.
# Collision protection and Prefix compat for eapi < 3.
font_pkg_setup() {
	# Prefix compat
	case ${EAPI:-0} in
		0|1|2)
			if ! use prefix; then
				EPREFIX=
				ED=${D}
				EROOT=${ROOT}
				[[ ${EROOT} = */ ]] || EROOT+="/"
			fi
			;;
	esac

	# make sure we get no collisions
	# setup is not the nicest place, but preinst doesn't cut it
	[[ -e "${EROOT}/${FONTDIR}/fonts.cache-1" ]] && rm -f "${EROOT}/${FONTDIR}/fonts.cache-1"
}

# @FUNCTION: font_src_install
# @DESCRIPTION:
# The font src_install function.
font_src_install() {
	local dir suffix commondoc

	set -- ${FONT_S:-${S}}
	if [[ $# -gt 1 ]]; then
		# if we have multiple FONT_S elements then we want to recreate the dir
		# structure
		for dir in ${FONT_S}; do
			pushd "${dir}" > /dev/null
			insinto "${FONTDIR}/${dir//${S}/}"
			for suffix in ${FONT_SUFFIX}; do
				doins *.${suffix}
			done
			font_xfont_config "${dir}"
			popd > /dev/null
		done
	else
		pushd "${FONT_S}" > /dev/null
		insinto "${FONTDIR}"
		for suffix in ${FONT_SUFFIX}; do
			doins *.${suffix}
		done
		font_xfont_config
		popd > /dev/null
	fi

	font_fontconfig

	[[ -n ${DOCS} ]] && { dodoc ${DOCS} || die "docs installation failed" ; }

	# install common docs
	for commondoc in COPYRIGHT README{,.txt} NEWS AUTHORS BUGS ChangeLog FONTLOG.txt; do
		[[ -s ${commondoc} ]] && dodoc ${commondoc}
	done
}

# @FUNCTION: font_pkg_postinst
# @DESCRIPTION:
# The font pkg_postinst function.
font_pkg_postinst() {
	# unreadable font files = fontconfig segfaults
	find "${EROOT}"usr/share/fonts/ -type f '!' -perm 0644 -print0 \
		| xargs -0 chmod -v 0644 2>/dev/null

	if [[ -n ${FONT_CONF[@]} ]]; then
		local conffile
		echo
		elog "The following fontconfig configuration files have been installed:"
		elog
		for conffile in "${FONT_CONF[@]}"; do
			if [[ -e ${EROOT}etc/fonts/conf.avail/$(basename ${conffile}) ]]; then
				elog "  $(basename ${conffile})"
			fi
		done
		elog
		elog "Use \`eselect fontconfig\` to enable/disable them."
		echo
	fi

	if has_version media-libs/fontconfig && [[ ${ROOT} == / ]]; then
		ebegin "Updating global fontcache"
		fc-cache -fs
		eend $?
	else
		einfo "Skipping fontcache update (media-libs/fontconfig is not installed or ROOT != /)"
	fi
}

# @FUNCTION: font_pkg_postrm
# @DESCRIPTION:
# The font pkg_postrm function.
font_pkg_postrm() {
	font_cleanup_dirs

	# unreadable font files = fontconfig segfaults
	find "${EROOT}"usr/share/fonts/ -type f '!' -perm 0644 -print0 \
		| xargs -0 chmod -v 0644 2>/dev/null

	if has_version media-libs/fontconfig && [[ ${ROOT} == / ]]; then
		ebegin "Updating global fontcache"
		fc-cache -fs
		eend $?
	else
		einfo "Skipping fontcache update (media-libs/fontconfig is not installed or ROOT != /)"
	fi
}
