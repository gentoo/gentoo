# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: Please bump in sync with dev-libs/libxslt

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="xml(+)"
inherit python-r1 meson-multilib

XSTS_HOME="https://www.w3.org/XML/2004/xml-schema-test-suite"
XSTS_NAME_1="xmlschema2002-01-16"
XSTS_NAME_2="xmlschema2004-01-14"
XSTS_TARBALL_1="xsts-2002-01-16.tar.gz"
XSTS_TARBALL_2="xsts-2004-01-14.tar.gz"
XMLCONF_TARBALL="xmlts20130923.tar.gz"

DESCRIPTION="XML C parser and toolkit"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/libxml2"
	inherit git-r3
else
	inherit gnome.org
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

SRC_URI+="
	test? (
		${XSTS_HOME}/${XSTS_NAME_1}/${XSTS_TARBALL_1}
		${XSTS_HOME}/${XSTS_NAME_2}/${XSTS_TARBALL_2}
		https://www.w3.org/XML/Test/${XMLCONF_TARBALL}
	)
"
S="${WORKDIR}/${PN}-${PV%_rc*}"

LICENSE="MIT"
# see so_version = v_maj + v_min_compat for subslot
SLOT="2/16"
IUSE="icu +python readline static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	virtual/libiconv
	>=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	icu? ( >=dev-libs/icu-51.2-r1:=[${MULTILIB_USEDEP}] )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/xml2-config
)

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	else
		local tarname=${P/_rc/-rc}.tar.xz

		# ${A} isn't used to avoid unpacking of test tarballs into ${WORKDIR},
		# as they are needed as tarballs in ${S}/xstc instead and not unpacked
		unpack ${tarname}

		if [[ -n ${PATCHSET_VERSION} ]] ; then
			unpack ${PN}-${PATCHSET_VERSION}.tar.xz
		fi
	fi

	cd "${S}" || die

	if use test ; then
		cp "${DISTDIR}/${XSTS_TARBALL_1}" \
			"${DISTDIR}/${XSTS_TARBALL_2}" \
			"${S}"/xstc/ \
			|| die "Failed to install test tarballs"
		unpack ${XMLCONF_TARBALL}
	fi
}

src_prepare() {
	default

	sed -e "/^dir_doc/ s/meson.project_name()$/\'${PF}\'/" -i meson.build || die
}

python_configure() {
	local emesonargs=(
		$(meson_feature icu)
		$(meson_native_use_feature readline)
		$(meson_native_use_feature readline history)
		-Dpython=enabled
	)
	mkdir "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" >/dev/null || die
	meson_src_configure
	popd >/dev/null || die
}

multilib_src_configure() {
	local emesonargs=(
		-Ddefault_library=$(multilib_native_usex static-libs both shared)
		$(meson_feature icu)
		$(meson_native_use_feature readline)
		$(meson_native_use_feature readline history)
		-Dpython=disabled

		# There has been a clean break with a soname bump.
		# It's time to deal with the breakage.
		# bug #935452
		-Dlegacy=disabled
	)
	meson_src_configure

	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_configure
	fi
}

python_compile() {
	pushd "${BUILD_DIR}" >/dev/null || die
	meson_src_compile
	popd >/dev/null || die
}

multilib_src_compile() {
	meson_src_compile

	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_compile
	fi
}

multilib_src_test() {
	meson_src_test

	if multilib_is_native_abi && use python ; then
		python_foreach_impl meson_src_test
	fi
}

python_install() {
	pushd "${BUILD_DIR}" >/dev/null || die
	meson_src_install
	python_optimize
	popd >/dev/null || die
}

multilib_src_install() {
	if multilib_is_native_abi && use python ; then
		python_foreach_impl python_install
	fi

	meson_src_install
}

pkg_postinst() {
	# We don't want to do the xmlcatalog during stage1, as xmlcatalog will not
	# be in / and stage1 builds to ROOT=/tmp/stage1root. This fixes bug #208887.
	if [[ -n "${ROOT}" ]]; then
		elog "Skipping XML catalog creation for stage building (bug #208887)."
	else
		# Need an XML catalog, so no-one writes to a non-existent one
		CATALOG="${EROOT}/etc/xml/catalog"

		# We don't want to clobber an existing catalog though,
		# only ensure that one is there
		# <obz@gentoo.org>
		if [[ ! -e "${CATALOG}" ]]; then
			[[ -d "${EROOT}/etc/xml" ]] || mkdir -p "${EROOT}/etc/xml"
			"${EPREFIX}"/usr/bin/xmlcatalog --create > "${CATALOG}"
			einfo "Created XML catalog in ${CATALOG}"
		fi
	fi
}
