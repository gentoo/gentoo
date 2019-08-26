# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: libretro-core.eclass
# @MAINTAINER:
# candrews@gentoo.org
# @AUTHOR:
# Cecil Curry <leycec@gmail.com>
# Craig Andrews <candrews@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: Simplify libretro core ebuilds
# @DESCRIPTION:
# The libretro eclass is designed to streamline the construction of
# ebuilds for Libretro core ebuilds.
#
# Libretro cores can be found under https://github.com/libretro/
#
# They all use the same basic make based build system, are located
# in the same github account, and do not release named or numbered
# versions (so ebuild versions for git commits are keys).
# This eclass covers those commonalities reducing much duplication
# between the ebuilds.
# @EXAMPLE:
# @CODE
# EAPI=7
#
# LIBRETRO_CORE_NAME="2048"
# LIBRETRO_COMMIT_SHA="45655d3662e4cbcd8afb28e2ee3f5494a75888de"
# KEYWORDS="~amd64 ~x86"
# inherit libretro-core
#
# DESCRIPTION="Port of 2048 puzzle game to the libretro API"
# LICENSE="Unlicense"
# SLOT="0"
# @CODE

if [[ -z ${_LIBRETRO_CORE_ECLASS} ]]; then
_LIBRETRO_CORE_ECLASS=1

IUSE="debug"

# @ECLASS-VARIABLE: LIBRETRO_CORE_NAME
# @REQUIRED
# @DESCRIPTION:
# Name of this Libretro core. The libretro-core_src_install() phase function
# will install the shared library "${S}/${LIBRETRO_CORE_NAME}_libretro.so" as a
# Libretro core. Defaults to the name of the current package with the
# "libretro-" prefix excluded and hyphens replaced with underscores
# (e.g. genesis_plus_gx for libretro-genesis-plus-gx)
if [[ -z "${LIBRETRO_CORE_NAME}" ]]; then
	LIBRETRO_CORE_NAME=${PN#libretro-}
	LIBRETRO_CORE_NAME=${LIBRETRO_CORE_NAME//-/_}
fi

# @ECLASS-VARIABLE: LIBRETRO_COMMIT_SHA
# @DESCRIPTION:
# Commit SHA used for SRC_URI will die if not set in <9999 ebuilds.
# Needs to be set before inherit.

# @ECLASS-VARIABLE: LIBRETRO_REPO_NAME
# @REQUIRED
# @DESCRIPTION:
# Contains the real repo name of the core formatted as "repouser/reponame".
# Needs to be set before inherit. Otherwise defaults to "libretro/${PN}"
: ${LIBRETRO_REPO_NAME:="libretro/libretro-${LIBRETRO_CORE_NAME}"}

: ${HOMEPAGE:="https://github.com/${LIBRETRO_REPO_NAME}"}

if [[ ${PV} == *9999 ]]; then
	: ${EGIT_REPO_URI:="https://github.com/${LIBRETRO_REPO_NAME}.git"}
	inherit git-r3
else
	[[ -z "${LIBRETRO_COMMIT_SHA}" ]] && die "LIBRETRO_COMMIT_SHA must be set before inherit."
	S="${WORKDIR}/${LIBRETRO_REPO_NAME##*/}-${LIBRETRO_COMMIT_SHA}"
	: ${SRC_URI:="https://github.com/${LIBRETRO_REPO_NAME}/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"}
fi
inherit flag-o-matic

case "${EAPI:-0}" in
	6|7)
		EXPORT_FUNCTIONS src_unpack src_prepare src_compile src_install
		;;
	*)
		die "EAPI=${EAPI} is not supported" ;;
esac

# @FUNCTION: libretro-core_src_unpack
# @DESCRIPTION:
# The libretro-core src_unpack function which is exported.
#
# This function retrieves the remote Libretro core info files.
libretro-core_src_unpack() {
	# If this is a live ebuild, retrieve this core's remote repository.
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		# Add used commit SHA for version information, the above could also work.
		LIBRETRO_COMMIT_SHA=$(git -C "${WORKDIR}/${P}" rev-parse HEAD)
	# Else, unpack this core's local tarball.
	else
		default_src_unpack
	fi
}

# @FUNCTION: libretro-core_src_prepare
# @DESCRIPTION:
# The libretro-core src_prepare function which is exported.
#
# This function prepares the source by making custom modifications.
libretro-core_src_prepare() {
	default_src_prepare
	# Populate COMMIT for GIT_VERSION
	local custom_libretro_commit_sha="\" ${LIBRETRO_COMMIT_SHA:0:7}\""
	local makefile
	local flags_modified=0
	local shopt_saved=$(shopt -p nullglob)
	shopt -s nullglob
	for makefile in "${S}"/[Mm]akefile* "${S}"/target-libretro/[Mm]akefile*; do
		# * Convert CRLF to LF
		# * Expand *FLAGS to prevent potential self-references
		# * Where LDFLAGS directly define the link version
		#   script append LDFLAGS and LIBS
		# * Where SHARED is used to provide shared linking
		#   flags ensure final link command includes LDFLAGS
		#   and LIBS
		# * Always use $(CFLAGS) when calling $(CC)
		# * Add short-rev to Makefile
		sed \
			-e 's/\r$//g' \
			-e "/flags.*=/s:-O[[:digit:]]:${CFLAGS}:g" \
			-e "/CFLAGS.*=/s:-O[[:digit:]]:${CFLAGS}:g" \
			-e "/CXXFLAGS.*=/s:-O[[:digit:]]:${CXXFLAGS}:g" \
			-e "/.*,--version-script=.*/s:$: ${LDFLAGS} ${LIBS}:g" \
			-e "/\$(CC)/s:\(\$(SHARED)\):\1 ${LDFLAGS} ${LIBS}:" \
			-e 's:\(\$(CC)\):\1 \$(CFLAGS):g' \
			-e "s/GIT_VERSION\s.=.*$/GIT_VERSION=${custom_libretro_commit_sha}/g" \
			-i "${makefile}" || die "Failed to use custom cflags in ${makefile}"
	done
	${shopt_saved}
	export OPTFLAGS="${CFLAGS}"
}

# @VARIABLE: myemakeargs
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optional emake arguments as a bash array. Should be defined before calling
# src_compile.
# @CODE
# src_compile() {
#	local myemakeargs=(
#		$(usex neon "HAVE_NEON=1" "")
#	)
#	libretro-core_src_compile
# }
# @CODE

# @FUNCTION: libretro-core_src_compile
# @DESCRIPTION:
# The libretro-core src_compile function which is exported.
#
# This function compiles the shared library for this Libretro core.
libretro-core_src_compile() {
	# most (if not all) libretro makefiles use DEBUG=1
	# to enable additional debug features.
	emake CC=$(tc-getCC) CXX=$(tc-getCXX) \
		$(usex debug "DEBUG=1" "") "${myemakeargs[@]}" \
		$([[ -f makefile.libretro ]] && echo '-f makefile.libretro') \
		$([[ -f Makefile.libretro ]] && echo '-f Makefile.libretro')
}

# @VARIABLE: LIBRETRO_CORE_LIB_FILE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Absolute path of this Libretro core's shared library.
# src_install.
# @CODE
# src_install() {
# 	local LIBRETRO_CORE_LIB_FILE="${S}/somecore_libretro.so"
#
# 	libretro-core_src_install
# }
# @CODE

# @FUNCTION: libretro-core_src_install
# @DESCRIPTION:
# The libretro-core src_install function which is exported.
#
# This function installs the shared library for this Libretro core.
libretro-core_src_install() {
	local LIBRETRO_CORE_LIB_FILE=${LIBRETRO_CORE_LIB_FILE:-"${S}/${LIBRETRO_CORE_NAME}_libretro.so"}

	# Absolute path of the directory containing Libretro shared libraries.
	local libretro_lib_dir="/usr/$(get_libdir)/libretro"
	# If this core's shared library exists, install that.
	if [[ -f "${LIBRETRO_CORE_LIB_FILE}" ]]; then
		exeinto "${libretro_lib_dir}"
		doexe "${LIBRETRO_CORE_LIB_FILE}"
	else
		# Basename of this library.
		local lib_basename="${LIBRETRO_CORE_LIB_FILE##*/}"

		# Absolute path to which this library was installed.
		local lib_file_target="${ED}${libretro_lib_dir}/${lib_basename}"

		# If this library was *NOT* installed, fail.
		[[ -f "${lib_file_target}" ]] ||
			die "Libretro core shared library \"${lib_file_target}\" not installed."
	fi
}

fi # end _LIBRETRO_CORE_ECLASS guard
