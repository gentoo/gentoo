# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes
AUTOTOOLS_IN_SOURCE_BUILD=yes

inherit autotools-utils flag-o-matic systemd toolchain-funcs

KEYWORDS="~amd64"

PXE_VERSION="794.1.0"
PXE_SYSTEMD_VERSION="v222"
PXE_URI="http://alpha.release.core-os.net/amd64-usr/${PXE_VERSION}/coreos_production_pxe_image.cpio.gz"
PXE_FILE="${PN}-pxe-${PXE_VERSION}.img"

SRC_URI="https://github.com/coreos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
rkt_stage1_coreos? ( $PXE_URI -> $PXE_FILE )"

DESCRIPTION="A CLI for running app containers, and an implementation of the App
Container Spec."
HOMEPAGE="https://github.com/coreos/rkt"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc examples +rkt_stage1_coreos +rkt_stage1_fly +actool"
REQUIRED_USE="|| ( rkt_stage1_coreos rkt_stage1_fly )"

DEPEND=">=dev-lang/go-1.4.1
	app-arch/cpio
	sys-fs/squashfs-tools
	dev-perl/Capture-Tiny"

RDEPEND="!app-emulation/rocket"

BUILDDIR="build-${P}"
STAGE1_DEFAULT_LOCATION="/usr/share/rkt/stage1.aci"

src_configure() {
	local flavors myeconfargs=(
		--with-stage1-default-images-directory="/usr/share/rkt"
		--with-stage1-default-location="${STAGE1_DEFAULT_LOCATION}"
	)

	# TODO:
	#  - fix rkt_stage1_kvm to not download kernel sources with wget
	#  - fix rkt_stage1_src to not download systemd sources with git clone
	#  - fix rkt_stage1_host to not fail during launch

	# enable flavors (first is default)
	use rkt_stage1_coreos && flavors+=",coreos"
	use rkt_stage1_fly && flavors+=",fly"
	myeconfargs+=( --with-stage1-flavors="${flavors#,}" )

	if use rkt_stage1_coreos; then
		myeconfargs+=(
			--with-coreos-local-pxe-image-path="${DISTDIR}/${PXE_FILE}"
			--with-coreos-local-pxe-image-systemd-version="${PXE_SYSTEMD_VERSION}"
		)
	fi

	# Go's 6l linker does not support PIE, disable so cgo binaries
	# which use 6l+gcc for linking can be built correctly.
	if gcc-specs-pie; then
		append-ldflags -nopie
	fi

	export CC=$(tc-getCC)
	export CGO_ENABLED=1
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"
	export BUILDDIR

	autotools-utils_src_configure
}

src_install() {
	dodoc README.md
	use doc && dodoc -r Documentation
	use examples && dodoc -r examples
	use actool && dobin "${S}/${BUILDDIR}/bin/actool"

	dobin "${S}/${BUILDDIR}/bin/rkt"

	insinto /usr/share/rkt
	doins "${S}/${BUILDDIR}/bin/"*.aci

	# create symlink for default stage1 image path
	if use rkt_stage1_coreos; then
		dosym stage1-coreos.aci "${STAGE1_DEFAULT_LOCATION}"
	elif use rkt_stage1_fly; then
		dosym stage1-fly.aci "${STAGE1_DEFAULT_LOCATION}"
	fi

	systemd_dounit "${S}"/dist/init/systemd/${PN}-gc.service
	systemd_dounit "${S}"/dist/init/systemd/${PN}-gc.timer
	systemd_dounit "${S}"/dist/init/systemd/${PN}-metadata.service
	systemd_dounit "${S}"/dist/init/systemd/${PN}-metadata.socket
}
