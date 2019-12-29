# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kde5.eclass
# @MAINTAINER:
# kde@gentoo.org
# @SUPPORTED_EAPIS: 7
# @BLURB: Support eclass for packages that follow KDE packaging conventions.
# @DESCRIPTION:
# This eclass is *deprecated*. Please read the PORTING notes for switching to
# ecm.eclass in case the package is using extra-cmake-modules, otherwise just
# use cmake.eclass instead. For projects hosted on kde.org infrastructure,
# inherit kde.org.eclass to fetch and unpack sources independent of the build
# system being used.
#
# This eclass unconditionally inherits kde5-functions.eclass and all its public
# functions and variables may be considered as part of this eclass's API.
#
# This eclass unconditionally inherits kde.org.eclass and either ecm.eclass if
# KDE_AUTODEPS=true (default) or cmake.eclass if KDE_AUTODEPS=false.
# All their public variables and helper functions (not phase functions) may
# be considered as part of this eclass's API.
#
# This eclass's phase functions are not intended to be mixed and matched, so if
# any phase functions are overridden the version here should also be called.

if [[ -z ${_KDE5_ECLASS} ]]; then
_KDE5_ECLASS=1

# Propagate KMNAME to kde.org.eclass
# PORTING: Use KDE_ORG_NAME from kde.org.eclass instead
if [[ -z ${KDE_ORG_NAME} ]]; then
	KDE_ORG_NAME=${KMNAME:=$PN}
fi

inherit flag-o-matic kde.org kde5-functions xdg

# @ECLASS-VARIABLE: KDE_AUTODEPS
# @DESCRIPTION:
# If set to "false", do nothing.
# For any other value, add dependencies on dev-qt/qtcore:5, kde-frameworks/kf-env
# and kde-frameworks/extra-cmake-modules:5. Additionally, required blockers may
# be set depending on the value of CATEGORY.
# PORTING: no replacement
: ${KDE_AUTODEPS:=true}

# @ECLASS-VARIABLE: KDE_DEBUG
# @DESCRIPTION:
# If set to "false", add -DNDEBUG (via cmake_src_configure) and -DQT_NO_DEBUG
# to CPPFLAGS.
# Otherwise, add debug to IUSE.
# PORTING: ECM_DEBUG in ecm.eclass
: ${KDE_DEBUG:=true}

# @ECLASS-VARIABLE: KDE_DESIGNERPLUGIN
# @DESCRIPTION:
# If set to "false", do nothing.
# Otherwise, add "designer" to IUSE to toggle build of designer plugins
# and add the necessary DEPENDs.
# PORTING: ECM_DESIGNERPLUGIN in ecm.eclass
: ${KDE_DESIGNERPLUGIN:=false}

# @ECLASS-VARIABLE: KDE_EXAMPLES
# @DESCRIPTION:
# If set to "false", unconditionally ignore a top-level examples subdirectory.
# Otherwise, add "examples" to IUSE to toggle adding that subdirectory.
# PORTING: ECM_EXAMPLES in ecm.eclass
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
# PORTING: ECM_HANDBOOK in ecm.eclass
: ${KDE_HANDBOOK:=false}

# @ECLASS-VARIABLE: KDE_DOC_DIR
# @DESCRIPTION:
# Specifies the location of the KDE handbook if not the default.
# PORTING: ECM_HANDBOOK_DIR in ecm.eclass
: ${KDE_DOC_DIR:=doc}

# @ECLASS-VARIABLE: KDE_PO_DIRS
# @DESCRIPTION:
# Specifies the possible locations of KDE l10n files if not the default.
# PORTING: ECM_PO_DIRS in ecm.eclass
: ${KDE_PO_DIRS:="po poqm"}

# @ECLASS-VARIABLE: KDE_QTHELP
# @DESCRIPTION:
# If set to "false", do nothing.
# Otherwise, add "doc" to IUSE, add the appropriate dependency, generate
# and install Qt compressed help files with -DBUILD_QCH=ON when USE=doc.
# PORTING: ECM_QTHELP in ecm.eclass
if [[ ${CATEGORY} = kde-frameworks ]]; then
	: ${KDE_QTHELP:=true}
fi
: ${KDE_QTHELP:=false}

# @ECLASS-VARIABLE: KDE_TEST
# @DESCRIPTION:
# If set to "false", do nothing.
# For any other value, add test to IUSE and add a dependency on dev-qt/qttest:5.
# If set to "optional", configure with -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=ON
# when USE=!test.
# If set to "forceoptional", remove a Qt5Test dependency and comment test
# subdirs from the root CMakeLists.txt in addition to the above.
# If set to "forceoptional-recursive", remove Qt5Test dependencies and make
# autotest(s), unittest(s) and test(s) subdirs from *any* CMakeLists.txt in ${S}
# and below conditional on BUILD_TESTING. This is always meant as a short-term
# fix and creates ${T}/${P}-tests-optional.patch to refine and submit upstream.
# PORTING: ECM_TEST in ecm.eclass
if [[ ${CATEGORY} = kde-frameworks ]]; then
	: ${KDE_TEST:=true}
fi
: ${KDE_TEST:=false}

# @ECLASS-VARIABLE: KDE_SUBSLOT
# @DESCRIPTION:
# If set to "false", do nothing.
# If set to "true", add a subslot to the package, where subslot is either
# defined as major.minor version for kde-*/ categories or ${PV} if other.
# For any other value, that value will be used as subslot.
# PORTING: no replacement, define in ebuild
: ${KDE_SUBSLOT:=false}

# PORTING: LICENSE no longer set by eclass, define in ebuild
LICENSE="GPL-2"
# PORTING: SLOT no longer set by eclass except for kde-frameworks
[[ ${CATEGORY} = kde-frameworks ]] || SLOT=5

case ${KDE_SUBSLOT} in
	false)  ;;
	true)
		case ${CATEGORY} in
			kde-frameworks | \
			kde-plasma | \
			kde-apps)
				SLOT+="/$(ver_cut 1-2)"
				;;
			*)
				SLOT+="/${PV}"
				;;
		esac
		;;
	*)
		SLOT+="/${KDE_SUBSLOT}"
		;;
esac

case ${KDE_AUTODEPS} in
	false)
		inherit cmake
		# @ECLASS-VARIABLE: ECM_KDEINSTALLDIRS
		# @DESCRIPTION:
		# If set to "false", do nothing.
		# For any other value, assume the package is using KDEInstallDirs macro and switch
		# KDE_INSTALL_USE_QT_SYS_PATHS to ON.
		: ${ECM_KDEINSTALLDIRS:=true}

		case ${KDE_DEBUG} in
			false)	;;
			*)
				IUSE+=" debug"
				;;
		esac

		case ${KDE_TEST} in
			false)	;;
			*)
				IUSE+=" test"
				DEPEND+=" test? ( dev-qt/qttest:5 )"
				;;
		esac
		;;
	*)
		# all packages need breeze/oxygen icons for basic iconset, bug #564838
		if [[ ${PN} != breeze-icons && ${PN} != oxygen-icons ]]; then
			ECM_NONGUI=false
		fi
		# propagate deprecated variables to ecm.eclass
		if [[ -z ${ECM_DESIGNERPLUGIN} && ${CATEGORY} != kde-apps ]]; then
			ECM_DESIGNERPLUGIN=${KDE_DESIGNERPLUGIN}
			KDE_DESIGNERPLUGIN=false # use fallback var only for kde-apps
		fi
		[[ -z ${ECM_DEBUG} ]] && ECM_DEBUG=${KDE_DEBUG}
		[[ -z ${ECM_EXAMPLES} ]] && ECM_EXAMPLES=${KDE_EXAMPLES}
		[[ -z ${ECM_HANDBOOK} ]] && ECM_HANDBOOK=${KDE_HANDBOOK}
		[[ -z ${ECM_HANDBOOK_DIR} ]] && ECM_HANDBOOK_DIR=${KDE_DOC_DIR}
		[[ -z ${ECM_PO_DIRS} ]] && ECM_PO_DIRS=${KDE_PO_DIRS}
		[[ -z ${ECM_QTHELP} ]] && ECM_QTHELP=${KDE_QTHELP}
		[[ -z ${ECM_TEST} ]] && ECM_TEST=${KDE_TEST}
		[[ -z ${KFMIN} ]] && KFMIN=${FRAMEWORKS_MINIMAL}
		inherit ecm
		;;
esac

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_test src_install pkg_preinst pkg_postinst pkg_postrm

# @FUNCTION: _kde5_strip_handbook_translations
# @INTERNAL
# @DESCRIPTION:
# If LINGUAS is defined, enable only the requested translations when required.
_kde5_strip_handbook_translations() {
	if ! [[ -v LINGUAS ]]; then
		return
	fi

	local lang po
	for po in ${ECM_PO_DIRS}; do
		if [[ -d ${po} ]] ; then
			pushd ${po} > /dev/null || die
			local lang
			for lang in *; do
				if [[ -e ${lang} ]] && ! has ${lang/.po/} ${LINGUAS} ; then
					case ${lang} in
						cmake_modules | \
						CMakeLists.txt | \
						${PN}.pot)	;;
						*) rm -r ${lang} || die	;;
					esac
					if [[ -e CMakeLists.txt ]] ; then
						cmake_comment_add_subdirectory ${lang}
						sed -e "/add_subdirectory([[:space:]]*${lang}\/.*[[:space:]]*)/d" \
							-i CMakeLists.txt || die
					fi
				fi
			done
			popd > /dev/null || die
		fi
	done
}

# @FUNCTION: cmake_use_find_package
# @USAGE: <USE flag> <package name>
# @DESCRIPTION:
# Compatibility alias for cmake.eclass -> cmake.eclass
cmake-utils_use_find_package() {
	cmake_use_find_package "$@" ;
}

# @FUNCTION: kde5_pkg_pretend
# @DESCRIPTION:
# Checks if the active compiler meets the minimum version requirements.
# phase function is only exported if KDE_GCC_MINIMAL is defined.
kde5_pkg_pretend() {
	debug-print-function ${FUNCNAME} "$@"
	case ${KDE_AUTODEPS} in
		false) ;;
		*) ecm_pkg_pretend ;;
	esac
}

# @FUNCTION: kde5_pkg_setup
# @DESCRIPTION:
# Checks if the active compiler meets the minimum version requirements.
kde5_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"
	case ${KDE_AUTODEPS} in
		false) ;;
		*) ecm_pkg_setup ;;
	esac
}

# @FUNCTION: kde5_src_unpack
# @DESCRIPTION:
# Unpack the sources, automatically handling both release and live ebuilds.
kde5_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"
	kde.org_src_unpack
}

# @FUNCTION: kde5_src_prepare
# @DESCRIPTION:
# Wrapper for cmake_src_prepare with lots of extra logic for magic
# handling of linguas, tests, handbook etc.
kde5_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"
	case ${KDE_AUTODEPS} in
		false)
			cmake_src_prepare

			_kde5_strip_handbook_translations

			# only build unit tests when required
			if ! { in_iuse test && use test; } ; then
				if [[ ${KDE_TEST} = forceoptional ]] ; then
					punt_bogus_dep Qt5 Test
					# if forceoptional, also cover non-kde categories
					cmake_comment_add_subdirectory autotests test tests
				elif [[ ${CATEGORY} = kde-frameworks || ${CATEGORY} = kde-plasma || ${CATEGORY} = kde-apps ]] ; then
					cmake_comment_add_subdirectory autotests test tests
				fi
			fi
			# in frameworks, tests = manual tests so never build them
			if [[ ${CATEGORY} = kde-frameworks ]] && [[ ${PN} != extra-cmake-modules ]]; then
				cmake_comment_add_subdirectory tests
			fi
			;;
		*) ecm_src_prepare ;;
	esac

	# PORTING: bogus, overzealous 'en' docbook disabling is not carried over
	if [[ ${KDE_BUILD_TYPE} = release && ${CATEGORY} != kde-apps ]] ; then
		if [[ ${KDE_HANDBOOK} != false && -d ${KDE_DOC_DIR} && -v LINGUAS ]] ; then
			pushd ${KDE_DOC_DIR} > /dev/null || die
			local lang
			for lang in *; do
				if ! has ${lang} ${LINGUAS} ; then
					cmake_comment_add_subdirectory ${lang}
				fi
			done
			popd > /dev/null || die
		fi
	fi
}

# @FUNCTION: kde5_src_configure
# @DESCRIPTION:
# Wrapper for cmake_src_configure with extra logic for magic handling of
# handbook, tests etc.
kde5_src_configure() {
	debug-print-function ${FUNCNAME} "$@"
	case ${KDE_AUTODEPS} in
		false)
			# we rely on cmake.eclass to append -DNDEBUG too
			if in_iuse debug && ! use debug; then
				append-cppflags -DQT_NO_DEBUG
			fi

			local cmakeargs

			if in_iuse test && ! use test ; then
				cmakeargs+=( -DBUILD_TESTING=OFF )

				if [[ ${KDE_TEST} = optional ]] ; then
					cmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=ON )
				fi
			fi
			if [[ ${ECM_KDEINSTALLDIRS} != false ]] ; then
				cmakeargs+=(
					# install mkspecs in the same directory as qt stuff
					-DKDE_INSTALL_USE_QT_SYS_PATHS=ON
					# move handbook outside of doc dir, bug 667138
					-DKDE_INSTALL_DOCBUNDLEDIR="${EPREFIX}/usr/share/help"
				)
			fi

			# allow the ebuild to override what we set here
			mycmakeargs=("${cmakeargs[@]}" "${mycmakeargs[@]}")

			cmake_src_configure
			;;
		*) ecm_src_configure ;;
	esac
}

# @FUNCTION: kde5_src_compile
# @DESCRIPTION:
# Wrapper for cmake_src_compile. Currently doesn't do anything extra, but
# is included as part of the API just in case it's needed in the future.
kde5_src_compile() {
	debug-print-function ${FUNCNAME} "$@"
	case ${KDE_AUTODEPS} in
		false) cmake_src_compile ;;
		*) ecm_src_compile ;;
	esac
}

# @FUNCTION: kde5_src_test
# @DESCRIPTION:
# Wrapper for cmake_src_test with extra logic for magic handling of dbus
# and virtualx.
kde5_src_test() {
	debug-print-function ${FUNCNAME} "$@"
	case ${KDE_AUTODEPS} in
		false) cmake_src_test ;;
		*) ecm_src_test ;;
	esac
}

# @FUNCTION: kde5_src_install
# @DESCRIPTION:
# Wrapper for cmake_src_install. Currently doesn't do anything extra.
kde5_src_install() {
	debug-print-function ${FUNCNAME} "$@"
	case ${KDE_AUTODEPS} in
		false) cmake_src_install ;;
		*) ecm_src_install ;;
	esac
}

# @FUNCTION: kde5_pkg_preinst
# @DESCRIPTION:
# Sets up environment variables required in kde5_pkg_postinst.
kde5_pkg_preinst() {
	debug-print-function ${FUNCNAME} "$@"
	case ${KDE_AUTODEPS} in
		false) xdg_pkg_preinst ;;
		*) ecm_pkg_preinst ;;
	esac
}

# @FUNCTION: kde5_pkg_postinst
# @DESCRIPTION:
# Updates the various XDG caches (icon, desktop, mime) if necessary.
kde5_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"
	case ${KDE_AUTODEPS} in
		false) xdg_pkg_postinst ;;
		*) ecm_pkg_postinst ;;
	esac
}

# @FUNCTION: kde5_pkg_postrm
# @DESCRIPTION:
# Updates the various XDG caches (icon, desktop, mime) if necessary.
kde5_pkg_postrm() {
	debug-print-function ${FUNCNAME} "$@"
	case ${KDE_AUTODEPS} in
		false) xdg_pkg_postrm ;;
		*) ecm_pkg_postrm ;;
	esac
}

fi
