# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

inherit cmake-utils eutils flag-o-matic gnome2-utils kde5-functions versionator virtualx xdg

if [[ ${KDE_BUILD_TYPE} = live ]]; then
	case ${KDE_SCM} in
		git) inherit git-r3 ;;
	esac
fi

if [[ -v KDE_GCC_MINIMAL ]]; then
	EXPORT_FUNCTIONS pkg_pretend
fi

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_test src_install pkg_preinst pkg_postinst pkg_postrm

# @ECLASS-VARIABLE: QT_MINIMAL
# @DESCRIPTION:
# Minimal Qt version to require for the package.
: ${QT_MINIMAL:=5.5.1}

# @ECLASS-VARIABLE: KDE_AUTODEPS
# @DESCRIPTION:
# If set to "false", do nothing.
# For any other value, add a dependency on dev-qt/qtcore:5 and kde-frameworks/extra-cmake-modules:5.
: ${KDE_AUTODEPS:=true}

# @ECLASS-VARIABLE: KDE_BLOCK_SLOT4
# @DESCRIPTION:
# This variable is used when KDE_AUTODEPS is set.
# If set to "true", add RDEPEND block on kde-apps/${PN}:4
: ${KDE_BLOCK_SLOT4:=true}

# @ECLASS-VARIABLE: KDE_DEBUG
# @DESCRIPTION:
# If set to "false", unconditionally build with -DNDEBUG.
# Otherwise, add debug to IUSE to control building with that flag.
: ${KDE_DEBUG:=true}

# @ECLASS-VARIABLE: KDE_DESIGNERPLUGIN
# @DESCRIPTION:
# If set to "false", do nothing.
# Otherwise, add "designer" to IUSE to toggle build of designer plugins
# and add the necessary DEPENDs.
: ${KDE_DESIGNERPLUGIN:=false}

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
# If set to "optional", config with -DCMAKE_DISABLE_FIND_PACKAGE_KF5DocTools=ON
# when USE=!handbook. In case package requires KF5KDELibs4Support, see next:
# If set to "forceoptional", remove a KF5DocTools dependency from the root
# CMakeLists.txt in addition to the above.
: ${KDE_HANDBOOK:=false}

# @ECLASS-VARIABLE: KDE_DOC_DIR
# @DESCRIPTION:
# Defaults to "doc". Otherwise, use alternative KDE handbook path.
: ${KDE_DOC_DIR:=doc}

# @ECLASS-VARIABLE: KDE_TEST
# @DESCRIPTION:
# If set to "false", do nothing.
# For any other value, add test to IUSE and add a dependency on dev-qt/qttest:5.
# If set to "optional", configure with -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=ON
# when USE=!test.
# If set to "forceoptional", remove a Qt5Test dependency from the root
# CMakeLists.txt in addition to the above.
if [[ ${CATEGORY} = kde-frameworks ]]; then
	: ${KDE_TEST:=true}
else
	: ${KDE_TEST:=false}
fi

# @ECLASS-VARIABLE: KDE_L10N
# @DESCRIPTION:
# This is an array of translations this ebuild supports. These translations
# are automatically added to IUSE.
if [[ ${KDEBASE} = kdel10n ]]; then
	if [[ -n ${KDE_L10N} ]]; then
		IUSE="${IUSE} $(printf 'l10n_%s ' ${KDE_L10N[@]})"
	fi
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
	HOMEPAGE="https://www.kdevelop.org/"
elif [[ ${KDEBASE} = kdel10n ]]; then
	HOMEPAGE="http://l10n.kde.org"
else
	HOMEPAGE="https://www.kde.org/"
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
		COMMONDEPEND+=" $(add_qt_dep qtcore)"

		if [[ ${CATEGORY} = kde-plasma ]]; then
			if [[ $(get_version_component_range 2) -eq 6 && $(get_version_component_range 3) -ge 5 ]]; then
				QT_MINIMAL=5.6.1
			fi
			if [[ $(get_version_component_range 2) -ge 7 || ${PV} = 9999 ]]; then
				QT_MINIMAL=5.6.1
				FRAMEWORKS_MINIMAL=5.23.0
			fi
		fi

		if [[ ${CATEGORY} = kde-frameworks || ${CATEGORY} = kde-plasma && ${PN} != polkit-kde-agent ]]; then
			RDEPEND+="
				!kde-apps/kde4-l10n[-minimal(+)]
				!<kde-apps/kde4-l10n-15.12.3-r1
			"
		fi

		if [[ ${KDE_BLOCK_SLOT4} = true && ${CATEGORY} = kde-apps ]]; then
			RDEPEND+=" !kde-apps/${PN}:4"
		fi
		;;
esac

case ${KDE_DEBUG} in
	false)	;;
	*)
		IUSE+=" debug"
		;;
esac

case ${KDE_DESIGNERPLUGIN} in
	false)  ;;
	*)
		IUSE+=" designer"
		DEPEND+=" designer? (
			$(add_frameworks_dep kdesignerplugin)
			$(add_qt_dep designer)
		)"
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
		DEPEND+=" test? ( $(add_qt_dep qttest) )"
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
		kross)
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
			local plasmapv=$(get_version_component_range 1-3)

			case ${PV} in
				5.?.[6-9]? )
					# Plasma 5 beta releases
					SRC_URI="mirror://kde/unstable/plasma/${plasmapv}/${_kmname}-${PV}.tar.xz"
					RESTRICT+=" mirror"
					;;
				*)
					# Plasma 5 stable releases
					SRC_URI="mirror://kde/stable/plasma/${plasmapv}/${_kmname}-${PV}.tar.xz" ;;
			esac
			;;
	esac

	if [[ ${KDEBASE} = kdel10n ]] ; then
		local uri_base="${SRC_URI/${_kmname}-${PV}.tar.xz/}kde-l10n/kde-l10n"
		SRC_URI=""
		for my_l10n in ${KDE_L10N[@]} ; do
			case ${my_l10n} in
				sr | sr-ijekavsk | sr-Latn-ijekavsk | sr-Latn)
					SRC_URI="${SRC_URI} l10n_${my_l10n}? ( ${uri_base}-sr-${PV}.tar.xz )"
					;;
				*)
					SRC_URI="${SRC_URI} l10n_${my_l10n}? ( ${uri_base}-$(kde_l10n2lingua ${my_l10n})-${PV}.tar.xz )"
					;;
			esac
		done
	fi
}

# Determine fetch location for live sources
_calculate_live_repo() {
	debug-print-function ${FUNCNAME} "$@"

	SRC_URI=""

	case ${KDE_SCM} in
		git)
			# @ECLASS-VARIABLE: EGIT_MIRROR
			# @DESCRIPTION:
			# This variable allows easy overriding of default kde mirror service
			# (anongit) with anything else you might want to use.
			EGIT_MIRROR=${EGIT_MIRROR:=https://anongit.kde.org}

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

			if [[ ${PV} == ??.??.49.9999 && ${CATEGORY} = kde-apps ]]; then
				EGIT_BRANCH="Applications/$(get_version_component_range 1-2)"
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
			git)
				git-r3_src_unpack
				;;
		esac
	elif [[ ${KDEBASE} = kdel10n ]]; then
		local l10npart=5
		[[ ${PN} = kde4-l10n ]] && l10npart=4
		mkdir -p "${S}" || die "Failed to create source dir ${S}"
		cd "${S}"
		for my_tar in ${A}; do
			tar -xpf "${DISTDIR}/${my_tar}" --xz \
				"${my_tar/.tar.xz/}/CMakeLists.txt" "${my_tar/.tar.xz/}/${l10npart}" 2> /dev/null ||
				elog "${my_tar}: tar extract command failed at least partially - continuing"
		done
	else
		default
	fi
}

# @FUNCTION: kde5_src_prepare
# @DESCRIPTION:
# Function for preparing the KDE 5 sources.
kde5_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${KDEBASE} = kdel10n ]]; then
		local l10npart=5
		[[ ${PN} = kde4-l10n ]] && l10npart=4
		# move known variant subdirs to root dir, currently sr@*
		use_if_iuse l10n_sr-ijekavsk && _l10n_variant_subdir2root sr-ijekavsk sr
		use_if_iuse l10n_sr-Latn-ijekavsk && _l10n_variant_subdir2root sr-Latn-ijekavsk sr
		use_if_iuse l10n_sr-Latn && _l10n_variant_subdir2root sr-Latn sr
		if use_if_iuse l10n_sr; then
			rm -rf kde-l10n-sr-${PV}/${l10npart}/sr/sr@* || die "Failed to cleanup L10N=sr"
			_l10n_variant_subdir_buster sr
		elif [[ -d kde-l10n-sr-${PV} ]]; then
			# having any variant selected means parent lingua will be unpacked as well
			rm -r kde-l10n-sr-${PV} || die "Failed to remove sr parent lingua"
		fi

		# add all l10n directories to cmake
		cat <<-EOF > CMakeLists.txt || die
project(${PN})
cmake_minimum_required(VERSION 2.8.12)
$(printf "add_subdirectory( %s )\n" \
	`find . -mindepth 1 -maxdepth 1 -type d | sed -e "s:^\./::"`)
EOF

		# for KF5: drop KDE4-based part; for KDE4: drop KF5-based part
		case ${l10npart} in
			5) find -maxdepth 2 -type f -name CMakeLists.txt -exec \
				sed -i -e "/add_subdirectory(4)/ s/^/#DONT/" {} + || die ;;
			4) find -maxdepth 2 -type f -name CMakeLists.txt -exec \
				sed -i -e "/add_subdirectory(5)/ s/^/#DONT/" {} + || die ;;
		esac
	fi

	cmake-utils_src_prepare

	# only build examples when required
	if ! use_if_iuse examples || ! use examples ; then
		cmake_comment_add_subdirectory examples
	fi

	# only enable handbook when required
	if ! use_if_iuse handbook ; then
		cmake_comment_add_subdirectory ${KDE_DOC_DIR}

		if [[ ${KDE_HANDBOOK} = forceoptional ]] ; then
			punt_bogus_dep KF5 DocTools
		fi
	fi

	# drop translations when nls is not wanted
	if [[ -d po ]] && in_iuse nls && ! use nls ; then
		rm -r po || die
	fi

	# enable only the requested translations
	# when required
	if [[ -d po && -v LINGUAS ]] ; then
		pushd po > /dev/null || die
		for lang in *; do
			if [[ -d ${lang} ]] && ! has ${lang} ${LINGUAS} ; then
				rm -r ${lang} || die
				if [[ -e CMakeLists.txt ]] ; then
					cmake_comment_add_subdirectory ${lang}
				fi
			elif ! has ${lang/.po/} ${LINGUAS} ; then
				if [[ ${lang} != CMakeLists.txt ]] ; then
					rm ${lang} || die
				fi
			fi
		done
		popd > /dev/null || die
	fi

	if [[ ${KDE_BUILD_TYPE} = release ]] ; then
		if [[ ${KDE_HANDBOOK} != false && -d ${KDE_DOC_DIR} && ${CATEGORY} != kde-apps ]] ; then
			pushd ${KDE_DOC_DIR} > /dev/null || die
			for lang in *; do
				if ! has ${lang} ${LINGUAS} ; then
					cmake_comment_add_subdirectory ${lang}
				fi
			done
			popd > /dev/null || die
		fi
	fi

	# in frameworks, tests = manual tests so never build them
	if [[ ${CATEGORY} = kde-frameworks ]] && [[ ${PN} != extra-cmake-modules ]]; then
		cmake_comment_add_subdirectory tests
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

	# only build unit tests when required
	if ! use_if_iuse test ; then
		if [[ ${KDE_TEST} = forceoptional ]] ; then
			punt_bogus_dep Qt5 Test
			# if forceoptional, also cover non-kde categories
			cmake_comment_add_subdirectory autotests
			cmake_comment_add_subdirectory test
			cmake_comment_add_subdirectory tests
		elif [[ ${CATEGORY} = kde-frameworks || ${CATEGORY} = kde-plasma || ${CATEGORY} = kde-apps ]] ; then
			cmake_comment_add_subdirectory autotests
			cmake_comment_add_subdirectory test
			cmake_comment_add_subdirectory tests
		fi
	fi
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

		if [[ ${KDE_TEST} = optional ]] ; then
			cmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=ON )
		fi
	fi

	if ! use_if_iuse handbook && [[ ${KDE_HANDBOOK} = optional ]] ; then
		cmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_KF5DocTools=ON )
	fi

	if ! use_if_iuse designer && [[ ${KDE_DESIGNERPLUGIN} != false ]] ; then
		cmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Designer=ON )
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
		virtx _test_runner
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
	xdg_pkg_preinst
}

# @FUNCTION: kde5_pkg_postinst
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been installed.
kde5_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	gnome2_icon_cache_update
	xdg_pkg_postinst
}

# @FUNCTION: kde5_pkg_postrm
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been removed.
kde5_pkg_postrm() {
	debug-print-function ${FUNCNAME} "$@"

	gnome2_icon_cache_update
	xdg_pkg_postrm
}

_l10n_variant_subdir2root() {
	local l10npart=5
	[[ ${PN} = kde4-l10n ]] && l10npart=4
	local lingua=$(kde_l10n2lingua ${1})
	local src=kde-l10n-${2}-${PV}
	local dest=kde-l10n-${lingua}-${PV}/${l10npart}

	# create variant rootdir structure from parent lingua and adapt it
	mkdir -p ${dest} || die "Failed to create ${dest}"
	mv ${src}/${l10npart}/${2}/${lingua} ${dest}/${lingua} || die "Failed to create ${dest}/${lingua}"
	cp -f ${src}/CMakeLists.txt kde-l10n-${lingua}-${PV} || die "Failed to prepare L10N=${1} subdir"
	echo "add_subdirectory(${lingua})" > ${dest}/CMakeLists.txt ||
		die "Failed to prepare ${dest}/CMakeLists.txt"
	cp -f ${src}/${l10npart}/${2}/CMakeLists.txt ${dest}/${lingua} ||
		die "Failed to create ${dest}/${lingua}/CMakeLists.txt"
	sed -e "s/${2}/${lingua}/" -i ${dest}/${lingua}/CMakeLists.txt ||
		die "Failed to prepare ${dest}/${lingua}/CMakeLists.txt"

	_l10n_variant_subdir_buster ${1}
}

_l10n_variant_subdir_buster() {
	local l10npart=5
	[[ ${PN} = kde4-l10n ]] && l10npart=4
	local dir=kde-l10n-$(kde_l10n2lingua ${1})-${PV}/${l10npart}/$(kde_l10n2lingua ${1})

	case ${l10npart} in
		5) sed -e "/^add_subdirectory(/d" -i ${dir}/CMakeLists.txt || die "Failed to cleanup ${dir} subdir" ;;
		4) sed -e "/^macro.*subdirectory(/d" -i ${dir}/CMakeLists.txt || die "Failed to cleanup ${dir} subdir" ;;
	esac

	for subdir in $(find ${dir} -mindepth 1 -maxdepth 1 -type d | sed -e "s:^\./::"); do
		echo "add_subdirectory(${subdir##*/})" >> ${dir}/CMakeLists.txt
	done
}

fi
