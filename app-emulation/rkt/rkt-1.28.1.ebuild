# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 autotools flag-o-matic systemd toolchain-funcs user

KEYWORDS="~amd64"

PXE_VERSION="1235.0.0"
PXE_SYSTEMD_VERSION="v231"
KVM_LINUX_VERSION="4.9.2"
KVMTOOL_VERSION="cfae4d64482ed745214e3c62dd84b79c2ae0f325"
QEMU_VERSION="v2.8.0"
PXE_URI="http://alpha.release.core-os.net/amd64-usr/${PXE_VERSION}/coreos_production_pxe_image.cpio.gz"
PXE_FILE="${PN}-pxe-${PXE_VERSION}.img"

SRC_URI_KVM="mirror://kernel/linux/kernel/v4.x/linux-${KVM_LINUX_VERSION}.tar.xz
	${PXE_URI} -> ${PXE_FILE}
"

SRC_URI="https://github.com/coreos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
rkt_stage1_coreos? ( $PXE_URI -> $PXE_FILE )
rkt_stage1_kvm_lkvm? (
	https://kernel.googlesource.com/pub/scm/linux/kernel/git/will/kvmtool/+archive/${KVMTOOL_VERSION}.tar.gz -> kvmtool-${KVMTOOL_VERSION}.tar.gz
	https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/patch/?id=c0a985531f49c06fd05069024f4664740e6a0baf -> kvmtool-include-sysmacros-c0a985531f49c06fd05069024f4664740e6a0baf.patch
	${SRC_URI_KVM}
)
rkt_stage1_kvm_qemu? (
	http://wiki.qemu-project.org/download/qemu-${QEMU_VERSION#v}.tar.bz2
	${SRC_URI_KVM}
)
rkt_stage1_src? ( https://github.com/systemd/systemd/archive/${PXE_SYSTEMD_VERSION}.tar.gz -> systemd-${PXE_SYSTEMD_VERSION#v}.tar.gz )"

DESCRIPTION="rkt is an App Container runtime for Linux"
HOMEPAGE="https://github.com/coreos/rkt"

LICENSE="Apache-2.0"
SLOT="0"
# The rkt_stage1_kvm flag has been replaced by the rkt_stage1_kvm_lkvm and rkt_stage1_kvm_qemu flags
IUSE="doc examples +rkt_stage1_coreos +rkt_stage1_fly rkt_stage1_host rkt_stage1_kvm rkt_stage1_kvm_lkvm rkt_stage1_kvm_qemu rkt_stage1_src +actool systemd"
REQUIRED_USE="!systemd? ( !rkt_stage1_host ) || ( rkt_stage1_coreos rkt_stage1_fly rkt_stage1_host rkt_stage1_kvm_lkvm rkt_stage1_kvm_qemu rkt_stage1_src ) !rkt_stage1_kvm"

# Some tests fail.
# rkt_stage1_src needs to copy /bin/mount, which requires root privileges during src_compile
RESTRICT="test rkt_stage1_src? ( userpriv )"

DEPEND=">=dev-lang/go-1.5
	app-arch/cpio
	app-crypt/trousers
	sys-fs/squashfs-tools
	dev-perl/Capture-Tiny
	rkt_stage1_src? ( >=sys-apps/util-linux-2.27 )
	rkt_stage1_kvm_qemu? (
		sys-apps/attr[static-libs(+)]
		sys-libs/libcap[static-libs(+)]
		sys-libs/zlib[static-libs(+)]
		>=x11-libs/pixman-0.28.0[static-libs(+)]
	)"

RDEPEND="!app-emulation/rocket
	rkt_stage1_host? ( systemd? (
		>=sys-apps/systemd-222
		app-shells/bash:0
	) )"

BUILDDIR="build-${P}"
STAGE1_DEFAULT_LOCATION="/usr/share/rkt/stage1.aci"

pkg_setup() {
	enewgroup rkt-admin
	enewgroup rkt
}

src_unpack() {
	local dest x
	for x in ${A}; do
		case ${x} in
			*.img|linux-*) continue ;;
			kvmtool-include-sysmacros-*) #627564
				dest=${S}/stage1/usr_from_kvm/lkvm/patches
				mkdir -p "${dest}" || die
				cp "${DISTDIR}/${x}" "${dest}" || die
				;;
			kvmtool-*)
				mkdir kvmtool || die
				pushd kvmtool >/dev/null || die
				unpack ${x}
				popd >/dev/null || die
				;;
			*)
				unpack ${x}
		esac
	done
}

src_prepare() {
	eapply_user

	# This patch breaks linux kernel cc-option checks when the
	# compiler doesn't recognize the -no-pie option.
	rm stage1/usr_from_kvm/kernel/patches/0002-for-debian-gcc.patch || die

	# avoid sdjournal include for bug 595874
	if ! use systemd; then
		sed -e "s/^\\(LOCAL_DIST_SRC_FILTER := .*\\)'$/\\1|api_service'/" \
			-i rkt/rkt.mk || die
	fi

	sed -e 's|^RKT_REQ_PROG(\[GIT\],.*|#\0|' -i configure.ac || die

	# disable git fetch of systemd
	sed -e 's~^include makelib/git.mk$~'\
'ifneq ($(wildcard $(RKT_STAGE1_SYSTEMD_SRC)),)\n\n'\
'get_systemd_sources: | $(UFS_SYSTEMDDIR)\n'\
'\tmv "$(RKT_STAGE1_SYSTEMD_SRC)" "$(UFS_SYSTEMD_SRCDIR)"\n\n'\
'$(UFS_SYSTEMD_CONFIGURE): get_systemd_sources\n\n'\
'else ifneq ($(wildcard $(UFS_SYSTEMD_SRCDIR)),)\n\n'\
'else\n'\
'\t\0\n'\
'endif~' -i stage1/usr_from_src/usr_from_src.mk || die

	# disable git fetch of kvmtool
	sed -e 's~^include makelib/git.mk$~'\
'ifneq ($(wildcard $(shell echo "$${WORKDIR}/kvmtool")),)\n\n'\
'$(call forward-vars, get_lkvm_sources, LKVM_SRCDIR)\n'\
'get_lkvm_sources: | $(LKVM_TMPDIR)\n'\
'\tmv "$${WORKDIR}/kvmtool" "$(LKVM_SRCDIR)"\n\n'\
'$(LKVM_PATCH_STAMP): get_lkvm_sources\n\n'\
'else ifneq ($(wildcard $(LKVM_SRCDIR)),)\n\n'\
'else\n'\
'\t\0\n'\
'endif~' -i stage1/usr_from_kvm/lkvm.mk || die

	# disable git fetch of qemu
	sed -e 's~^include makelib/git.mk$~'\
'ifneq ($(wildcard $(shell echo "$${WORKDIR}/qemu-'${QEMU_VERSION#v}'")),)\n\n'\
'$(call forward-vars, get_qemu_sources, QEMU_SRCDIR)\n'\
'get_qemu_sources: | $(QEMU_TMPDIR)\n'\
'\tmv "$${WORKDIR}/qemu-'${QEMU_VERSION#v}'" "$(QEMU_SRCDIR)"\n\n'\
'$(QEMU_CONF_STAMP): get_qemu_sources\n\n'\
'else ifneq ($(wildcard $(QEMU_SRCDIR)),)\n\n'\
'else\n'\
'\t\0\n'\
'endif~' \
	-e 's|QEMU_CONFIGURATION_OPTS :=|\0 --disable-bzip2 --disable-libssh2 --disable-opengl|' \
	-i stage1/usr_from_kvm/qemu.mk || die

	# disable fetch of kernel sources
	sed -e 's|wget .*|ln -s "$${DISTDIR}/linux-'${KVM_LINUX_VERSION}'.tar.xz" "$@"|' \
		-i stage1/usr_from_kvm/kernel.mk || die

	if use rkt_stage1_host; then
		# Make systemdUnitsPath consistent with host
		sed -e 's|\(systemdUnitsPath := \).*|\1"'$(systemd_get_systemunitdir)'"|' \
			-i stage1/init/init.go || die
	fi

	if use rkt_stage1_kvm_qemu; then
		sed '1i#include <sys/sysmacros.h>' -i "${WORKDIR}/qemu-${QEMU_VERSION#v}/hw/9pfs/9p.c" || die
	fi

	eautoreconf
}

src_configure() {
	local flavors hypervisors myeconfargs=(
		--with-stage1-default-images-directory="/usr/share/rkt"
		--with-stage1-default-location="${STAGE1_DEFAULT_LOCATION}"
	)

	use systemd || myeconfargs+=( --enable-sdjournal=no )

	# enable flavors (first is default)
	use rkt_stage1_host && flavors+=",host"
	use rkt_stage1_src && flavors+=",src"
	use rkt_stage1_coreos && flavors+=",coreos"
	use rkt_stage1_fly && flavors+=",fly"
	{ use rkt_stage1_kvm_lkvm || use rkt_stage1_kvm_qemu; } && flavors+=",kvm"
	myeconfargs+=( --with-stage1-flavors="${flavors#,}" )

	if use rkt_stage1_src; then
		myeconfargs+=(
			--with-stage1-systemd-version=${PXE_SYSTEMD_VERSION}
			--with-stage1-systemd-src="${WORKDIR}/systemd-${PXE_SYSTEMD_VERSION#v}"
		)
	fi

	if use rkt_stage1_coreos || use rkt_stage1_kvm_lkvm || use rkt_stage1_kvm_qemu; then
		myeconfargs+=(
			--with-coreos-local-pxe-image-path="${DISTDIR}/${PXE_FILE}"
			--with-coreos-local-pxe-image-systemd-version="${PXE_SYSTEMD_VERSION}"
		)
	fi

	if use rkt_stage1_kvm_lkvm || use rkt_stage1_kvm_qemu; then
		use rkt_stage1_kvm_lkvm && hypervisors+=",lkvm"
		use rkt_stage1_kvm_qemu && hypervisors+=",qemu"
		myeconfargs+=( --with-stage1-kvm-hypervisors="${hypervisors#,}" )
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

	econf "${myeconfargs[@]}"
}

src_compile() {
	local arch=${ARCH}
	case ${arch} in
		amd64) arch=x86_64;;
	esac
	ARCH=${arch} emake V=3
	ARCH=${arch} emake V=3 bash-completion
}

src_install() {
	dodoc README.md
	use doc && dodoc -r Documentation
	use examples && dodoc -r examples
	use actool && dobin "${S}/${BUILDDIR}/tools/actool"

	dobin "${S}/${BUILDDIR}/target/bin/rkt"

	insinto /usr/share/rkt
	doins "${S}/${BUILDDIR}/target/bin/"*.aci

	# create symlink for default stage1 image path
	if use rkt_stage1_host; then
		dosym stage1-host.aci "${STAGE1_DEFAULT_LOCATION}"
	elif use rkt_stage1_src; then
		dosym stage1-src.aci "${STAGE1_DEFAULT_LOCATION}"
	elif use rkt_stage1_coreos; then
		dosym stage1-coreos.aci "${STAGE1_DEFAULT_LOCATION}"
	elif use rkt_stage1_fly; then
		dosym stage1-fly.aci "${STAGE1_DEFAULT_LOCATION}"
	elif use rkt_stage1_kvm_lkvm; then
		dosym stage1-kvm-lkvm.aci "${STAGE1_DEFAULT_LOCATION}"
	elif use rkt_stage1_kvm_qemu; then
		dosym stage1-kvm-qemu.aci "${STAGE1_DEFAULT_LOCATION}"
	fi

	systemd_dounit "${S}"/dist/init/systemd/*.service \
		"${S}"/dist/init/systemd/*.timer \
		"${S}"/dist/init/systemd/*.socket

	insinto /usr/lib/tmpfiles.d
	doins "${S}"/dist/init/systemd/tmpfiles.d/*

	newbashcomp "${S}"/dist/bash_completion/rkt.bash rkt

	keepdir /etc/${PN}
	fowners :rkt-admin /etc/${PN}
	fperms 2775 /etc/${PN}
}
