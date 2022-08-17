# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: font.eclass
# @MAINTAINER:
# fonts@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass to make font installation uniform

case ${EAPI:-0} in
	[7-8]) ;;
	*) die "EAPI ${EAPI} is not supported by font.eclass." ;;
esac

if [[ ! ${_FONT_ECLASS} ]]; then
_FONT_ECLASS=1

EXPORT_FUNCTIONS pkg_setup src_install pkg_postinst pkg_postrm

# @ECLASS_VARIABLE: FONT_SUFFIX
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# Space delimited list of font suffixes to install.
FONT_SUFFIX=${FONT_SUFFIX:-}

# @ECLASS_VARIABLE: FONT_S
# @DEFAULT_UNSET
# @DESCRIPTION:
# Directory containing the fonts.  If unset, ${S} is used instead.
# Can also be an array of several directories.

# @ECLASS_VARIABLE: FONT_PN
# @DESCRIPTION:
# Font name (ie. last part of FONTDIR).
FONT_PN=${FONT_PN:-${PN}}

# @ECLASS_VARIABLE: FONTDIR
# @DESCRIPTION:
# Full path to installation directory.
FONTDIR=${FONTDIR:-/usr/share/fonts/${FONT_PN}}

# @ECLASS_VARIABLE: FONT_CONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing fontconfig conf files to install.
FONT_CONF=( "" )

if [[ ${CATEGORY}/${PN} != media-fonts/encodings ]]; then
	IUSE="X"
	BDEPEND="X? (
			>=x11-apps/mkfontscale-1.2.0
			media-fonts/encodings
	)"
fi

# @FUNCTION: font_xfont_config
# @DESCRIPTION:
# Generate Xorg font files (mkfontscale/mkfontdir).
font_xfont_config() {
	local dir_name
	if in_iuse X && use X ; then
		dir_name="${1:-${FONT_PN}}"
		rm -f "${ED}${FONTDIR}/${1//${S}/}"/{fonts.{dir,scale},encodings.dir} \
			|| die "failed to prepare ${FONTDIR}/${1//${S}/}"
		einfo "Creating fonts.scale & fonts.dir in ${dir_name##*/}"
		mkfontscale "${ED}${FONTDIR}/${1//${S}/}" || eerror "failed to create fonts.scale"
		mkfontdir \
			-e "${EPREFIX}"/usr/share/fonts/encodings \
			-e "${EPREFIX}"/usr/share/fonts/encodings/large \
			"${ED}${FONTDIR}/${1//${S}/}" || eerror "failed to create fonts.dir"
		[[ -e fonts.alias ]] && doins fonts.alias
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
			[[ -e ${conffile} ]] && doins "${conffile}"
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
	while read -d $'\0' -r; do
		candidate=false
		otherfile=false
		for f in "${d}"/*; do
			generated=false
			# make sure this is a file and not a subdir
			[[ -e ${f} || -L ${f} ]] || continue
			if has ${f##*/} ${genfiles}; then
				# this is a generated file
				generated=true
				break
			fi
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
				if [[ ${g} != fonts.alias && ( -e ${d}/${g} || -L ${d}/${g} ) ]] ; then
					rm "${d}"/${g} || eerror "failed to remove ${d}/${g}"
				fi
			done
			# if there's nothing left remove the directory
			find "${d}" -maxdepth 0 -type d -empty -delete || eerror "failed to purge ${d}"
		fi
	done < <(find -L "${EROOT}"/usr/share/fonts/ -type d -print0)
	eend 0
}

# @FUNCTION: font_pkg_setup
# @DESCRIPTION:
# The font pkg_setup function.
# Collision protection
font_pkg_setup() {
	# make sure we get no collisions
	# setup is not the nicest place, but preinst doesn't cut it
	if [[ -e "${EROOT}${FONTDIR}/fonts.cache-1" ]] ; then
		rm "${EROOT}${FONTDIR}/fonts.cache-1" || die "failed to remove fonts.cache-1"
	fi
}

# @FUNCTION: font_src_install
# @DESCRIPTION:
# The font src_install function.
font_src_install() {
	local dir suffix commondoc

	if [[ $(declare -p FONT_S 2>/dev/null) == "declare -a"* ]]; then
		# recreate the directory structure if FONT_S is an array
		for dir in "${FONT_S[@]}"; do
			pushd "${dir}" > /dev/null || die "pushd ${dir} failed"
			insinto "${FONTDIR}/${dir#"${S}"}"
			for suffix in ${FONT_SUFFIX}; do
				doins *.${suffix}
			done
			font_xfont_config "${dir}"
			popd > /dev/null || die
		done
	else
		pushd "${FONT_S:-${S}}" > /dev/null \
			|| die "pushd ${FONT_S:-${S}} failed"
		insinto "${FONTDIR}"
		for suffix in ${FONT_SUFFIX}; do
			doins *.${suffix}
		done
		font_xfont_config
		popd > /dev/null || die
	fi

	font_fontconfig

	einstalldocs

	# install common docs
	for commondoc in COPYRIGHT FONTLOG.txt; do
		[[ -s ${commondoc} ]] && dodoc ${commondoc}
	done
}

# @FUNCTION: _update_fontcache
# @DESCRIPTION:
# Updates fontcache if !prefix and media-libs/fontconfig installed
_update_fontcache() {
	# unreadable font files = fontconfig segfaults
	find "${EROOT}"/usr/share/fonts/ -type f '!' -perm 0644 \
		-exec chmod -v 0644 2>/dev/null {} + || die "failed to fix font files perms"

	if [[ -z ${ROOT} ]] ; then
		if has_version media-libs/fontconfig ; then
			ebegin "Updating global fontcache"
			fc-cache -fs
			if ! eend $? ; then
				die "failed to update global fontcache"
			fi
		else
			einfo "Skipping fontcache update (media-libs/fontconfig not installed)"
		fi
	else
		einfo "Skipping fontcache update (ROOT != /)"
	fi
}

# @FUNCTION: font_pkg_postinst
# @DESCRIPTION:
# The font pkg_postinst function.
font_pkg_postinst() {
	if [[ -n ${FONT_CONF[@]} ]]; then
		local conffile
		elog "The following fontconfig configuration files have been installed:"
		elog
		for conffile in "${FONT_CONF[@]}"; do
			[[ -e "${EROOT}"/etc/fonts/conf.avail/${conffile##*/} ]] &&
				elog "  ${conffile##*/}"
		done
		elog
		elog "Use \`eselect fontconfig\` to enable/disable them."
	fi

	_update_fontcache
}

# @FUNCTION: font_pkg_postrm
# @DESCRIPTION:
# The font pkg_postrm function.
font_pkg_postrm() {
	font_cleanup_dirs
	_update_fontcache
}

fi
