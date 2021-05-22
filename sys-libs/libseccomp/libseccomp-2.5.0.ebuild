# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 multilib-minimal

DESCRIPTION="high level interface to Linux seccomp filter"
HOMEPAGE="https://github.com/seccomp/libseccomp"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/seccomp/libseccomp.git"
	PRERELEASE="2.6.0"
	inherit autotools git-r3
else
	SRC_URI="https://github.com/seccomp/libseccomp/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="-* ~amd64 ~arm ~arm64 ~hppa -mips ~ppc ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="python static-libs"

REQUIRED_USE="
	python? (
		static-libs
		${PYTHON_REQUIRED_USE}
	)"

BDEPEND="
	dev-util/gperf
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${BDEPEND}"
RDEPEND="${DEPEND}"

# We need newer kernel headers; we don't keep strict control of the exact
# version here, just be safe and pull in the latest stable ones. #551248
DEPEND="${DEPEND} >=sys-kernel/linux-headers-4.3"

src_prepare() {
	default
	if [[ "${PV}" == *9999 ]] ; then
		sed -i -e "s/0.0.0/${PRERELEASE}/" configure.ac
		eautoreconf
	fi
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--disable-python
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi && use python ; then
		cd "${S}/src/python" || die
		sed -i -e "s/=.*VERSION_RELEASE.*,/=\"${PRERELEASE}\",/" \
			-e "/extra_objects/s,\.\.,${OLDPWD}/src," \
			setup.py || die
		local -x CPPFLAGS="-I${OLDPWD}/include -I../../include"
		distutils-r1_src_compile
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use python ; then
		cd "${S}/src/python" || die
		distutils-r1_src_install
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name "${PN}.la" -delete || die
	einstalldocs
}
