# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde5.eclass,v 1.14 2015/08/03 14:03:00 kensington Exp $

# @ECLASS: kde5.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: Support eclass for KDE 5-related packages.
# @DESCRIPTION:
# The kde5.eclass provides support for building KDE 5-related packages.

if [[ -z ${_KDE5_ECLASS} ]]; then
_KDE5_ECLASS=1

# @ECLASS-VARIABLE: VIRTUALX_REQUIRED
# @DESCRIPTION:
# For proper description see virtualx.eclass manpage.
# Here we redefine default value to be manual, if your package needs virtualx
# for tests you should proceed with setting VIRTUALX_REQUIRED=test.
: ${VIRTUALX_REQUIRED:=manual}

inherit kde5-functions fdo-mime flag-o-matic gnome2-utils versionator virtualx eutils cmake-utils

if [[ ${KDE_BUILD_TYPE} = live ]]; then
	case ${KDE_SCM} in
		svn) inherit subversion ;;
		git) inherit git-r3 ;;
	esac
fi

EXPORT_FUNCTIONS pkg_pretend pkg_setup src_unpack src_prepare src_configure src_compile src_test src_install pkg_preinst pkg_postinst pkg_postrm

# @ECLASS-VARIABLE: QT_MINIMAL
# @DESCRIPTION:
# Minimal Qt version to require for the package.
: ${QT_MINIMAL:=5.4.1}

# @ECLASS-VARIABLE: KDE_AUTODEPS
# @DESCRIPTION:
# If set to "false", do nothing.
# For any other value, add a dependency on dev-qt/qtcore:5 and kde-frameworks/extra-cmake-modules:5.
: ${KDE_AUTODEPS:=true}

# @ECLASS-VARIABLE: KDE_BLOCK_SLOT4
# @DESCRIPTION:
# This variable is used when KDE_AUTODEPS is set.
# If set to "true", add RDEPEND block on kde-{base,apps}/${PN}:4
: ${KDE_BLOCK_SLOT4:=true}

# @ECLASS-VARIABLE: KDE_DEBUG
# @DESCRIPTION:
# If set to "false", unconditionally build with -DNDEBUG.
# Otherwise, add debug to IUSE to control building with that flag.
: ${KDE_DEBUG:=true}

# @ECLASS-VARIABLE: KDE_DOXYGEN
# @DESCRIPTION:
# If set to "false", do nothing.
# Otherwise, add "doc" to IUSE, add appropriate dependencies, and generate and
# install API documentation.
if [[ ${CATEGORY} = kde-frameworks ]]; then
	: ${KDE_DOXYGEN:=true}
else
	: ${KDE_DOXYGEN:=false}
fi

# @ECLASS-VARIABLE: KDE_EXAMPLES
# @DESCRIPTION:
# If set to "false", unconditionally ignore a top-level examples subdirectory.
# Otherwise, add "examples" to IUSE to toggle adding that subdirectory.
: ${KDE_EXAMPLES:=false}

# @ECLASS-VARIABLE: KDE_HANDBOOK
# @DESCRIPTION:
# If set to "false", do nothing.
# Otherwise, add "+handbook" to IUSE, add the appropriate dependency, and
# generate and install KDE handbook.
: ${KDE_HANDBOOK:=false}

# @ECLASS-VARIABLE: KDE_TEST
# @DESCRIPTION:
# If set to "false", do nothing.
# For any other value, add test to IUSE and add a dependency on dev-qt/qttest:5.
if [[ ${CATEGORY} = kde-frameworks ]]; then
	: ${KDE_TEST:=true}
else
	: ${KDE_TEST:=false}
fi

# @ECLASS-VARIABLE: KDE_PUNT_BOGUS_DEPS
# @DESCRIPTION:
# If set to "false", do nothing.
# For any other value, do black magic to make hardcoded-but-optional dependencies
# optional again. An upstream solution is preferable and this is a last resort.
: ${KDE_PUNT_BOGUS_DEPS:=false}

# @ECLASS-VARIABLE: KDE_SELINUX_MODULE
# @DESCRIPTION:
# If set to "none", do nothing.
# For any other value, add selinux to IUSE, and depending on that useflag
# add a dependency on sec-policy/selinux-${KDE_SELINUX_MODULE} to (R)DEPEND.
: ${KDE_SELINUX_MODULE:=none}

if [[ ${KDEBASE} = kdevelop ]]; then
	HOMEPAGE="http://www.kdevelop.org/"
else
	HOMEPAGE="http://www.kde.org/"
fi

LICENSE="GPL-2"

if [[ ${CATEGORY} = kde-frameworks ]]; then
	SLOT=5/$(get_version_component_range 1-2)
else
	SLOT=5
fi

case ${KDE_AUTODEPS} in
	false)	;;
	*)
		if [[ ${KDE_BUILD_TYPE} = live ]]; then
			case ${CATEGORY} in
				kde-frameworks)
					FRAMEWORKS_MINIMAL=9999
				;;
				kde-plasma)
					FRAMEWORKS_MINIMAL=9999
				;;
				*) ;;
			esac
		fi

		DEPEND+=" $(add_frameworks_dep extra-cmake-modules)"
		RDEPEND+=" >=kde-frameworks/kf-env-3"
		COMMONDEPEND+="	>=dev-qt/qtcore-${QT_MINIMAL}:5"

		if [[ ${CATEGORY} = kde-plasma ]]; then
			RDEPEND+="
				!kde-apps/kde4-l10n[-minimal(-)]
				!kde-base/kde-l10n:4[-minimal(-)]
			"
		fi

		if [[ ${KDE_BLOCK_SLOT4} = true && ${CATEGORY} = kde-apps ]]; then
			RDEPEND+=" !kde-apps/${PN}:4"
		fi
		;;
esac

case ${KDE_DOXYGEN} in
	false)	;;
	*)
		IUSE+=" doc"
		DEPEND+=" doc? (
				$(add_frameworks_dep kapidox)
				app-doc/doxygen
			)"
		;;
esac

case ${KDE_DEBUG} in
	false)	;;
	*)
		IUSE+=" debug"
		;;
esac

case ${KDE_EXAMPLES} in
	false)  ;;
	*)
		IUSE+=" examples"
		;;
esac

case ${KDE_HANDBOOK} in
	false)	;;
	*)
		IUSE+=" +handbook"
		DEPEND+=" handbook? ( $(add_frameworks_dep kdoctools) )"
		;;
esac

case ${KDE_TEST} in
	false)	;;
	*)
		IUSE+=" test"
		DEPEND+=" test? ( >=dev-qt/qttest-${QT_MINIMAL}:5 )"
		;;
esac

case ${KDE_SELINUX_MODULE} in
	none)   ;;
	*)
		IUSE+=" selinux"
		RDEPEND+=" selinux? ( sec-policy/selinux-${KDE_SELINUX_MODULE} )"
		;;
esac

DEPEND+=" ${COMMONDEPEND} dev-util/desktop-file-utils"
RDEPEND+=" ${COMMONDEPEND}"
unset COMMONDEPEND

if [[ -n ${KMNAME} && ${KMNAME} != ${PN} && ${KDE_BUILD_TYPE} = release ]]; then
	S=${WORKDIR}/${KMNAME}-${PV}
fi

# Determine fetch location for released tarballs
_calculate_src_uri() {
	debug-print-function ${FUNCNAME} "$@"

	local _kmname

	if [[ -n ${KMNAME} ]]; then
		_kmname=${KMNAME}
	else
		_kmname=${PN}
	fi

	case ${PN} in
		kdelibs4support | \
		khtml | \
		kjs | \
		kjsembed | \
		kmediaplayer | \
		kross | \
		krunner)
			_kmname="portingAids/${_kmname}"
			;;
	esac

	DEPEND+=" app-arch/xz-utils"

	case ${CATEGORY} in
		kde-apps)
			case ${PV} in
				??.?.[6-9]? | ??.??.[6-9]? )
					SRC_URI="mirror://kde/unstable/applications/${PV}/src/${_kmname}-${PV}.tar.xz"
					RESTRICT+=" mirror"
					;;
				*)
					SRC_URI="mirror://kde/stable/applications/${PV}/src/${_kmname}-${PV}.tar.xz" ;;
			esac
			;;
		kde-frameworks)
			SRC_URI="mirror://kde/stable/frameworks/${PV%.*}/${_kmname}-${PV}.tar.xz" ;;
		kde-plasma)
			case ${PV} in
				5.?.[6-9]? )
					# Plasma 5 beta releases
					SRC_URI="mirror://kde/unstable/plasma/${PV}/${_kmname}-${PV}.tar.xz"
					RESTRICT+=" mirror"
					;;
				*)
					# Plasma 5 stable releases
					SRC_URI="mirror://kde/stable/plasma/${PV}/${_kmname}-${PV}.tar.xz" ;;
			esac
			;;
	esac
}

# Determine fetch location for live sources
_calculate_live_repo() {
	debug-print-function ${FUNCNAME} "$@"

	SRC_URI=""

	case ${KDE_SCM} in
		svn)
			# @ECLASS-VARIABLE: ESVN_MIRROR
			# @DESCRIPTION:
			# This variable allows easy overriding of default kde mirror service
			# (anonsvn) with anything else you might want to use.
			ESVN_MIRROR=${ESVN_MIRROR:=svn://anonsvn.kde.org/home/kde}

			local branch_prefix="KDE"

			if [[ -n ${KMNAME} ]]; then
				branch_prefix="${KMNAME}"
			fi

			ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${branch_prefix}/${PN}"
			;;
		git)
			# @ECLASS-VARIABLE: EGIT_MIRROR
			# @DESCRIPTION:
			# This variable allows easy overriding of default kde mirror service
			# (anongit) with anything else you might want to use.
			EGIT_MIRROR=${EGIT_MIRROR:=git://anongit.kde.org}

			local _kmname

			# @ECLASS-VARIABLE: EGIT_REPONAME
			# @DESCRIPTION:
			# This variable allows overriding of default repository
			# name. Specify only if this differ from PN and KMNAME.
			if [[ -n ${EGIT_REPONAME} ]]; then
				# the repository and kmname different
				_kmname=${EGIT_REPONAME}
			elif [[ -n ${KMNAME} ]]; then
				_kmname=${KMNAME}
			else
				_kmname=${PN}
			fi

			if [[ ${PV} != 9999 && ${CATEGORY} = kde-plasma ]]; then
				EGIT_BRANCH="Plasma/$(get_version_component_range 1-2)"
			fi

			EGIT_REPO_URI="${EGIT_MIRROR}/${_kmname}"
			;;
	esac
}

case ${KDE_BUILD_TYPE} in
	live) _calculate_live_repo ;;
	*) _calculate_src_uri ;;
esac

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: SRC_URI is ${SRC_URI}"

# @FUNCTION: kde5_pkg_pretend
# @DESCRIPTION:
# Do some basic settings
kde5_pkg_pretend() {
	debug-print-function ${FUNCNAME} "$@"
	_check_gcc_version
}

# @FUNCTION: kde5_pkg_setup
# @DESCRIPTION:
# Do some basic settings
kde5_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"
	_check_gcc_version
}

# @FUNCTION: kde5_src_unpack
# @DESCRIPTION:
# Function for unpacking KDE 5.
kde5_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${KDE_BUILD_TYPE} = live ]]; then
		case ${KDE_SCM} in
			svn)
				subversion_src_unpack
				;;
			git)
				git-r3_src_unpack
				;;
		esac
	else
		default
	fi
}

# @FUNCTION: kde5_src_prepare
# @DESCRIPTION:
# Function for preparing the KDE 5 sources.
kde5_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	# only build examples when required
	if ! use_if_iuse examples || ! use examples ; then
		comment_add_subdirectory examples
	fi

	# only enable handbook when required
	if ! use_if_iuse handbook ; then
		comment_add_subdirectory doc
	fi

	# enable only the requested translations
	# when required
	if [[ ${KDE_BUILD_TYPE} = release ]] ; then
		if [[ -d po ]] ; then
			pushd po > /dev/null
			for lang in *; do
				if ! has ${lang} ${LINGUAS} ; then
					if [[ ${lang} != CMakeLists.txt ]] ; then
						rm -rf ${lang}
					fi
					if [[ -e CMakeLists.txt ]] ; then
						comment_add_subdirectory ${lang}
					fi
				fi
			done
			popd > /dev/null
		fi

		if [[ ${KDE_HANDBOOK} = true ]] ; then
			pushd doc > /dev/null
			for lang in *; do
				if ! has ${lang} ${LINGUAS} ; then
					comment_add_subdirectory ${lang}
				fi
			done
			popd > /dev/null
		fi
	else
		rm -rf po
	fi

	# in frameworks, tests = manual tests so never
	# build them
	if [[ ${CATEGORY} = kde-frameworks ]]; then
		comment_add_subdirectory tests
	fi

	if [[ ${CATEGORY} = kde-frameworks || ${CATEGORY} = kde-plasma || ${CATEGORY} = kde-apps ]] ; then
		# only build unit tests when required
		if ! use_if_iuse test ; then
			comment_add_subdirectory autotests
			comment_add_subdirectory tests
		fi
	fi

	case ${KDE_PUNT_BOGUS_DEPS} in
		false)	;;
		*)
			if ! use_if_iuse test ; then
				punt_bogus_dep Qt5 Test
			fi
			if ! use_if_iuse handbook ; then
				punt_bogus_dep KF5 DocTools
			fi
			;;
	esac

	cmake-utils_src_prepare
}

# @FUNCTION: kde5_src_configure
# @DESCRIPTION:
# Function for configuring the build of KDE 5.
kde5_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	# we rely on cmake-utils.eclass to append -DNDEBUG too
	if ! use_if_iuse debug; then
		append-cppflags -DQT_NO_DEBUG
	fi

	local cmakeargs

	if ! use_if_iuse test ; then
		cmakeargs+=( -DBUILD_TESTING=OFF )
	fi

	# install mkspecs in the same directory as qt stuff
	cmakeargs+=(-DKDE_INSTALL_USE_QT_SYS_PATHS=ON)

	# allow the ebuild to override what we set here
	mycmakeargs=("${cmakeargs[@]}" "${mycmakeargs[@]}")

	cmake-utils_src_configure
}

# @FUNCTION: kde5_src_compile
# @DESCRIPTION:
# Function for compiling KDE 5.
kde5_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	cmake-utils_src_compile "$@"

	# Build doxygen documentation if applicable
	if use_if_iuse doc ; then
		kgenapidox . || die
	fi
}

# @FUNCTION: kde5_src_test
# @DESCRIPTION:
# Function for testing KDE 5.
kde5_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	_test_runner() {
		if [[ -n "${VIRTUALDBUS_TEST}" ]]; then
			export $(dbus-launch)
		fi

		cmake-utils_src_test
	}

	# When run as normal user during ebuild development with the ebuild command, the
	# kde tests tend to access the session DBUS. This however is not possible in a real
	# emerge or on the tinderbox.
	# > make sure it does not happen, so bad tests can be recognized and disabled
	unset DBUS_SESSION_BUS_ADDRESS DBUS_SESSION_BUS_PID

	if [[ ${VIRTUALX_REQUIRED} = always || ${VIRTUALX_REQUIRED} = test ]]; then
		VIRTUALX_COMMAND="_test_runner" virtualmake
	else
		_test_runner
	fi

	if [[ -n "${DBUS_SESSION_BUS_PID}" ]] ; then
		kill ${DBUS_SESSION_BUS_PID}
	fi
}

# @FUNCTION: kde5_src_install
# @DESCRIPTION:
# Function for installing KDE 5.
kde5_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	# Install doxygen documentation if applicable
	if use_if_iuse doc ; then
		dodoc -r apidocs/html
	fi

	cmake-utils_src_install

	# We don't want ${PREFIX}/share/doc/HTML to be compressed,
	# because then khelpcenter can't find the docs
	if [[ -d ${ED}/${PREFIX}/share/doc/HTML ]]; then
		docompress -x ${PREFIX}/share/doc/HTML
	fi
}

# @FUNCTION: kde5_pkg_preinst
# @DESCRIPTION:
# Function storing icon caches
kde5_pkg_preinst() {
	debug-print-function ${FUNCNAME} "$@"

	gnome2_icon_savelist
}

# @FUNCTION: kde5_pkg_postinst
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been installed.
kde5_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

# @FUNCTION: kde5_pkg_postrm
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been removed.
kde5_pkg_postrm() {
	debug-print-function ${FUNCNAME} "$@"

	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

fi
