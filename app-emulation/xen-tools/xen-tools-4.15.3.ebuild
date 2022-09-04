# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE='ncurses,xml(+),threads(+)'

inherit bash-completion-r1 flag-o-matic multilib python-single-r1 toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	REPO="xen.git"
	EGIT_REPO_URI="git://xenbits.xen.org/${REPO}"
	S="${WORKDIR}/${REPO}"
else
	KEYWORDS="amd64 ~arm ~arm64 x86"

	SEABIOS_VER="1.14.0"
	EDK2_COMMIT="7b4a99be8a39c12d3a7fc4b8db9f0eab4ac688d5"
	EDK2_OPENSSL_VERSION="1_1_1j"
	EDK2_SOFTFLOAT_COMMIT="b64af41c3276f97f0e181920400ee056b9c88037"
	EDK2_BROTLI_COMMIT="666c3280cc11dc433c303d79a83d4ffbdd12cc8d"
	IPXE_COMMIT="3c040ad387099483102708bb1839110bc788cefb"

	XEN_PRE_PATCHSET_NUM=
	XEN_GENTOO_PATCHSET_NUM=2
	XEN_PRE_VERSION_BASE=

	XEN_BASE_PV="${PV}"
	if [[ -n "${XEN_PRE_VERSION_BASE}" ]]; then
		XEN_BASE_PV="${XEN_PRE_VERSION_BASE}"
	fi

	SRC_URI="
	https://downloads.xenproject.org/release/xen/${XEN_BASE_PV}/xen-${XEN_BASE_PV}.tar.gz
	https://www.seabios.org/downloads/seabios-${SEABIOS_VER}.tar.gz
	ipxe? ( https://xenbits.xen.org/xen-extfiles/ipxe-git-${IPXE_COMMIT}.tar.gz )
	ovmf? ( https://github.com/tianocore/edk2/archive/${EDK2_COMMIT}.tar.gz -> edk2-${EDK2_COMMIT}.tar.gz
		https://github.com/openssl/openssl/archive/OpenSSL_${EDK2_OPENSSL_VERSION}.tar.gz
		https://github.com/ucb-bar/berkeley-softfloat-3/archive/${EDK2_SOFTFLOAT_COMMIT}.tar.gz -> berkeley-softfloat-${EDK2_SOFTFLOAT_COMMIT}.tar.gz
		https://github.com/google/brotli/archive/${EDK2_BROTLI_COMMIT}.tar.gz -> brotli-${EDK2_BROTLI_COMMIT}.tar.gz
	)
	"

	if [[ -n "${XEN_PRE_PATCHSET_NUM}" ]]; then
		XEN_UPSTREAM_PATCHES_TAG="$(ver_cut 1-3)-pre-patchset-${XEN_PRE_PATCHSET_NUM}"
		XEN_UPSTREAM_PATCHES_NAME="xen-upstream-patches-${XEN_UPSTREAM_PATCHES_TAG}"
		SRC_URI+=" https://gitweb.gentoo.org/proj/xen-upstream-patches.git/snapshot/${XEN_UPSTREAM_PATCHES_NAME}.tar.bz2"
		XEN_UPSTREAM_PATCHES_DIR="${WORKDIR}/${XEN_UPSTREAM_PATCHES_NAME}"
	fi
	if [[ -n "${XEN_GENTOO_PATCHSET_NUM}" ]]; then
		XEN_GENTOO_PATCHES_TAG="${PV}-gentoo-patchset-${XEN_GENTOO_PATCHSET_NUM}"
		XEN_GENTOO_PATCHES_NAME="xen-gentoo-patches-${XEN_GENTOO_PATCHES_TAG}"
		SRC_URI+=" https://gitweb.gentoo.org/proj/xen-gentoo-patches.git/snapshot/${XEN_GENTOO_PATCHES_NAME}.tar.bz2"
		XEN_GENTOO_PATCHES_DIR="${WORKDIR}/${XEN_GENTOO_PATCHES_NAME}"
	fi
fi

DESCRIPTION="Xen tools including QEMU and xl"
HOMEPAGE="https://xenproject.org"
DOCS=( README )

S="${WORKDIR}/xen-$(ver_cut 1-3 ${XEN_BASE_PV})"

LICENSE="GPL-2"
SLOT="0/$(ver_cut 1-2)"
# Inclusion of IUSE ocaml on stabalizing requires maintainer of ocaml to (get off his hands and) make
# >=dev-lang/ocaml-4 stable
# Masked in profiles/eapi-5-files instead
IUSE="api debug doc +hvm +ipxe lzma ocaml ovmf pygrub python +qemu +qemu-traditional +rombios screen selinux sdl static-libs system-ipxe system-qemu system-seabios"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	ipxe? ( rombios )
	ovmf? ( hvm )
	pygrub? ( python )
	rombios? ( hvm )
	system-ipxe? ( rombios )
	?? ( ipxe system-ipxe )
	?? ( qemu system-qemu )"

COMMON_DEPEND="
	lzma? ( app-arch/xz-utils )
	qemu? (
		dev-libs/glib:2
		sys-libs/pam
	)
	app-arch/bzip2
	dev-libs/libnl:3
	dev-libs/lzo:2
	dev-libs/yajl
	sys-apps/util-linux
	sys-fs/e2fsprogs
	sys-libs/ncurses
	sys-libs/zlib
	${PYTHON_DEPS}
"

RDEPEND="${COMMON_DEPEND}
	sys-apps/iproute2[-minimal]
	net-misc/bridge-utils
	screen? (
		app-misc/screen
		app-admin/logrotate
	)
	selinux? ( sec-policy/selinux-xen )"

DEPEND="${COMMON_DEPEND}
	app-misc/pax-utils
	>=sys-kernel/linux-headers-4.11
	x11-libs/pixman
	$(python_gen_cond_dep '
		dev-python/lxml[${PYTHON_USEDEP}]
	')
	x86? ( sys-devel/dev86
		system-ipxe? ( sys-firmware/ipxe[qemu] )
		sys-power/iasl )
	api? ( dev-libs/libxml2
		net-misc/curl )

	ovmf? (
		!arm? ( !arm64? ( dev-lang/nasm ) )
		$(python_gen_impl_dep sqlite)
		)
	!amd64? ( >=sys-apps/dtc-1.4.0 )
	amd64? ( sys-power/iasl
		system-seabios? ( sys-firmware/seabios )
		system-ipxe? ( sys-firmware/ipxe[qemu] )
		rombios? ( sys-devel/bin86 sys-devel/dev86 ) )
	arm64? ( sys-power/iasl
		rombios? ( sys-devel/bin86 sys-devel/dev86 ) )
	doc? (
		app-text/ghostscript-gpl
		app-text/pandoc
		$(python_gen_cond_dep '
			dev-python/markdown[${PYTHON_USEDEP}]
		')
		dev-texlive/texlive-latexextra
		media-gfx/transfig
	)
	hvm? ( x11-base/xorg-proto )
	qemu? (
		app-arch/snappy:=
		dev-util/meson
		sdl? (
			media-libs/libsdl[X]
			media-libs/libsdl2[X]
		)
	)
	system-qemu? ( app-emulation/qemu[xen] )
	ocaml? ( dev-ml/findlib
		dev-lang/ocaml[ocamlopt] )
	python? ( >=dev-lang/swig-4.0.0 )"

BDEPEND="dev-lang/perl
	sys-devel/bison
	sys-devel/gettext"

# hvmloader is used to bootstrap a fully virtualized kernel
# Approved by QA team in bug #144032
QA_WX_LOAD="
	usr/libexec/xen/boot/hvmloader
	usr/libexec/xen/boot/ovmf.bin
	usr/libexec/xen/boot/xen-shim
	usr/share/qemu-xen/qemu/hppa-firmware.img
	usr/share/qemu-xen/qemu/opensbi-riscv32-generic-fw_dynamic.elf
	usr/share/qemu-xen/qemu/opensbi-riscv64-generic-fw_dynamic.elf
	usr/share/qemu-xen/qemu/s390-ccw.img
	usr/share/qemu-xen/qemu/u-boot.e500
"

QA_EXECSTACK="
	usr/share/qemu-xen/qemu/hppa-firmware.img
"

QA_PREBUILT="
	usr/libexec/xen/bin/elf2dmp
	usr/libexec/xen/bin/ivshmem-client
	usr/libexec/xen/bin/ivshmem-server
	usr/libexec/xen/bin/qemu-edid
	usr/libexec/xen/bin/qemu-img
	usr/libexec/xen/bin/qemu-io
	usr/libexec/xen/bin/qemu-keymap
	usr/libexec/xen/bin/qemu-nbd
	usr/libexec/xen/bin/qemu-pr-helper
	usr/libexec/xen/bin/qemu-storage-daemon
	usr/libexec/xen/bin/qemu-system-i386
	usr/libexec/xen/bin/virtfs-proxy-helper
	usr/libexec/xen/boot/ovmf.bin
	usr/libexec/xen/boot/xen-shim
	usr/libexec/xen/libexec/qemu-pr-helper
	usr/libexec/xen/libexec/virtfs-proxy-helper
	usr/libexec/xen/libexec/virtiofsd
	usr/libexec/xen/libexec/xen-bridge-helper
	usr/share/qemu-xen/qemu/s390-ccw.img
	usr/share/qemu-xen/qemu/s390-netboot.img
	usr/share/qemu-xen/qemu/u-boot.e500
"

RESTRICT="test"

pkg_setup() {
	python_setup
	export "CONFIG_LOMOUNT=y"

	#bug 522642, disable compile tools/tests
	export "CONFIG_TESTS=n"

	if [[ -z ${XEN_TARGET_ARCH} ]] ; then
		if use x86 && use amd64; then
			die "Confusion! Both x86 and amd64 are set in your use flags!"
		elif use x86; then
			export XEN_TARGET_ARCH="x86_32"
		elif use amd64 ; then
			export XEN_TARGET_ARCH="x86_64"
		elif use arm; then
			export XEN_TARGET_ARCH="arm32"
		elif use arm64; then
			export XEN_TARGET_ARCH="arm64"
		else
			die "Unsupported architecture!"
		fi
	fi
}

src_prepare() {
	# move before Gentoo patch, one patch should apply to seabios, to fix gcc-4.5.x build err
	mv ../seabios-${SEABIOS_VER} tools/firmware/seabios-dir-remote || die
	pushd tools/firmware/ > /dev/null
	ln -s seabios-dir-remote seabios-dir || die
	popd > /dev/null

	if [[ -v XEN_UPSTREAM_PATCHES_DIR ]]; then
		eapply "${XEN_UPSTREAM_PATCHES_DIR}"
	fi

	if [[ -v XEN_GENTOO_PATCHES_DIR ]]; then
		eapply "${XEN_GENTOO_PATCHES_DIR}"
	fi

	# Rename qemu-bridge-helper to xen-bridge-helper to avoid file
	# collisions with app-emulation/qemu.
	sed -i 's/qemu-bridge-helper/xen-bridge-helper/g' \
		tools/qemu-xen/include/net/net.h \
		tools/qemu-xen/Makefile \
		tools/qemu-xen/qemu-bridge-helper.c \
		tools/qemu-xen/qemu-options.hx \
		|| die

	if use ovmf; then
		mv ../edk2-${EDK2_COMMIT} tools/firmware/ovmf-dir-remote || die
		rm -r tools/firmware/ovmf-dir-remote/CryptoPkg/Library/OpensslLib/openssl || die
		rm -r tools/firmware/ovmf-dir-remote/ArmPkg/Library/ArmSoftFloatLib/berkeley-softfloat-3 || die
		rm -r tools/firmware/ovmf-dir-remote/BaseTools/Source/C/BrotliCompress/brotli || die
		rm -r tools/firmware/ovmf-dir-remote/MdeModulePkg/Library/BrotliCustomDecompressLib/brotli || die
		mv ../openssl-OpenSSL_${EDK2_OPENSSL_VERSION} tools/firmware/ovmf-dir-remote/CryptoPkg/Library/OpensslLib/openssl || die
		mv ../berkeley-softfloat-3-${EDK2_SOFTFLOAT_COMMIT} tools/firmware/ovmf-dir-remote/ArmPkg/Library/ArmSoftFloatLib/berkeley-softfloat-3 || die
		cp -r ../brotli-${EDK2_BROTLI_COMMIT} tools/firmware/ovmf-dir-remote/BaseTools/Source/C/BrotliCompress/brotli || die
		cp -r ../brotli-${EDK2_BROTLI_COMMIT} tools/firmware/ovmf-dir-remote/MdeModulePkg/Library/BrotliCustomDecompressLib/brotli || die
		cp tools/firmware/ovmf-makefile tools/firmware/ovmf-dir-remote/Makefile || die

		# Bug #816987
		pushd tools/firmware/ovmf-dir-remote/BaseTools/Source/C/BrotliCompress/brotli > /dev/null
			eapply "${FILESDIR}/${PN}-4.15.1-brotli-gcc11.patch"
		popd > /dev/null

		pushd tools/firmware/ovmf-dir-remote/MdeModulePkg/Library/BrotliCustomDecompressLib/brotli > /dev/null
			eapply "${FILESDIR}/${PN}-4.15.1-brotli-gcc11.patch"
		popd > /dev/null
	fi

	# ipxe
	if use ipxe; then
		cp "${DISTDIR}/ipxe-git-${IPXE_COMMIT}.tar.gz" tools/firmware/etherboot/ipxe.tar.gz || die

		# gcc 11
		cp "${XEN_GENTOO_PATCHES_DIR}/ipxe/${PN}-4.15.0-ipxe-gcc11.patch" tools/firmware/etherboot/patches/ipxe-gcc11.patch || die
		echo ipxe-gcc11.patch >> tools/firmware/etherboot/patches/series || die
	fi

	mv tools/qemu-xen/qemu-bridge-helper.c tools/qemu-xen/xen-bridge-helper.c || die

	# Fix texi2html build error with new texi2html, qemu.doc.html
	sed -i -e "/texi2html -monolithic/s/-number//" tools/qemu-xen-traditional/Makefile || die

	# Drop .config, fixes to gcc-4.6
	sed -e '/-include $(XEN_ROOT)\/.config/d' -i Config.mk || die "Couldn't	drop"

	# drop flags
	unset CFLAGS
	unset LDFLAGS
	unset ASFLAGS
	unset CPPFLAGS

	if ! use pygrub; then
		sed -e '/^SUBDIRS-y += pygrub/d' -i tools/Makefile || die
	fi

	if ! use python; then
		sed -e '/^SUBDIRS-y += python$/d' -i tools/Makefile || die
	fi

	if ! use hvm; then
		sed -e '/SUBDIRS-$(CONFIG_X86) += firmware/d' -i tools/Makefile || die
	# Bug 351648
	elif ! use x86 && ! has x86 $(get_all_abis); then
		mkdir -p "${WORKDIR}"/extra-headers/gnu || die
		touch "${WORKDIR}"/extra-headers/gnu/stubs-32.h || die
		export CPATH="${WORKDIR}"/extra-headers
	fi

	if use qemu; then
		if use sdl; then
			sed -i -e "s:\$\$source/configure:\0 --enable-sdl:" \
				tools/Makefile || die
		else
			sed -i -e "s:\${QEMU_ROOT\:\-\.}/configure:\0 --disable-sdl:" \
				tools/qemu-xen-traditional/xen-setup || die
			sed -i -e "s:\$\$source/configure:\0 --disable-sdl:" \
				tools/Makefile || die
		fi
	else
		# Don't bother with qemu, only needed for fully virtualised guests
		sed -i '/SUBDIRS-$(CONFIG_QEMU_XEN)/s/^/#/g' tools/Makefile || die
	fi

	# Reset bash completion dir; Bug 472438
	sed -e "s;^BASH_COMPLETION_DIR      :=.*;BASH_COMPLETION_DIR := $(get_bashcompdir);" \
		-i config/Paths.mk.in || die

	# xencommons, Bug #492332, sed lighter weight than patching
	sed -e 's:\$QEMU_XEN -xen-domid:test -e "\$QEMU_XEN" \&\& &:' \
		-i tools/hotplug/Linux/init.d/xencommons.in || die

	# fix bashishm
	sed -e '/Usage/s/\$//g' \
		-i tools/hotplug/Linux/init.d/xendriverdomain.in || die

	# respect multilib, usr/lib/libcacard.so.0.0.0
	sed -e "/^libdir=/s/\/lib/\/$(get_libdir)/" \
		-i tools/qemu-xen/configure || die

	#bug 518136, don't build 32bit exactuable for nomultilib profile
	if [[ "${ARCH}" == 'amd64' ]] && ! has_multilib_profile; then
		sed -i -e "/x86_emulator/d" tools/tests/Makefile || die
	fi

	# uncomment lines in xl.conf
	sed -e 's:^#autoballoon=:autoballoon=:' \
		-e 's:^#lockfile=:lockfile=:' \
		-e 's:^#vif.default.script=:vif.default.script=:' \
		-i tools/examples/xl.conf  || die

	# disable capstone (Bug #673474)
	sed -e "s:\$\$source/configure:\0 --disable-capstone:" \
		-i tools/Makefile || die

	# disable glusterfs
	sed -e "s:\$\$source/configure:\0 --disable-glusterfs:" \
		-i tools/Makefile || die

	# disable jpeg automagic
	sed -e "s:\$\$source/configure:\0 --disable-vnc-jpeg:" \
		-i tools/Makefile || die

	# disable png automagic
	sed -e "s:\$\$source/configure:\0 --disable-vnc-png:" \
		-i tools/Makefile || die

	# disable docker (Bug #732970)
	sed -e "s:\$\$source/configure:\0 --disable-containers:" \
		-i tools/Makefile || die

	# disable abi-dumper (Bug #791172)
	sed -e 's/$(ABI_DUMPER) /echo /g' \
		-i tools/libs/libs.mk || die

	# Remove -Werror
	find . -type f \( -name Makefile -o -name "*.mk" \) \
		 -exec sed -i \
		 -e 's/-Werror //g' \
		 -e '/^CFLAGS *+= -Werror$/d' \
		 -e 's/, "-Werror"//' \
		 {} + || die

	default
}

src_configure() {
	local myconf=(
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--libexecdir="${EPREFIX}/usr/libexec"
		--localstatedir="${EPREFIX}/var"
		--disable-golang
		--disable-werror
		--disable-xen
		--enable-tools
		--enable-docs
		$(use_enable api xenapi)
		$(use_enable ipxe)
		$(usex system-ipxe '--with-system-ipxe=/usr/share/ipxe' '')
		$(use_enable ocaml ocamltools)
		$(use_enable ovmf)
		$(use_enable rombios)
		--with-xenstored=$(usex ocaml 'oxenstored' 'xenstored')
	)

	use system-seabios && myconf+=( --with-system-seabios=/usr/share/seabios/bios.bin )
	use system-qemu && myconf+=( --with-system-qemu=/usr/bin/qemu-system-x86_64 )
	use amd64 && myconf+=( $(use_enable qemu-traditional) )
	tc-ld-disable-gold # Bug 669570
	econf ${myconf[@]}
}

src_compile() {
	local myopt
	use debug && myopt="${myopt} debug=y"
	use python && myopt="${myopt} XENSTAT_PYTHON_BINDINGS=y"

	if test-flag-CC -fno-strict-overflow; then
		append-flags -fno-strict-overflow
	fi

	# bug #845099
	if use ipxe; then
		local -x NO_WERROR=1
	fi

	emake CC="$(tc-getCC)" LD="$(tc-getLD)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" build-tools ${myopt}

	if use doc; then
		emake -C docs build
	else
		emake -C docs man-pages
	fi
}

src_install() {
	# Override auto-detection in the build system, bug #382573
	export INITD_DIR=/tmp/init.d
	export CONFIG_LEAF_DIR=../tmp/default

	# Let the build system compile installed Python modules.
	local PYTHONDONTWRITEBYTECODE
	export PYTHONDONTWRITEBYTECODE

	emake DESTDIR="${ED}" DOCDIR="/usr/share/doc/${PF}" \
		XEN_PYTHON_NATIVE_INSTALL=y install-tools

	# Created at runtime
	rm -rv "${ED}/var/run" || die

	# Fix the remaining Python shebangs.
	python_fix_shebang "${D}"

	# Remove RedHat-specific stuff
	rm -rf "${D}"/tmp || die

	if use doc; then
		emake DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" install-docs
		dodoc -r docs/{pdf,txt}
	else
		emake -C docs DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" install-man-pages # Bug 668032
	fi
	dodoc ${DOCS[@]}

	newconfd "${FILESDIR}"/xendomains.confd xendomains
	newconfd "${FILESDIR}"/xenstored.confd xenstored
	newconfd "${FILESDIR}"/xenconsoled.confd xenconsoled
	newinitd "${FILESDIR}"/xendomains.initd-r2 xendomains
	newinitd "${FILESDIR}"/xenstored.initd-r1 xenstored
	newinitd "${FILESDIR}"/xenconsoled.initd xenconsoled
	newinitd "${FILESDIR}"/xencommons.initd xencommons
	newconfd "${FILESDIR}"/xencommons.confd xencommons
	newinitd "${FILESDIR}"/xenqemudev.initd xenqemudev
	newconfd "${FILESDIR}"/xenqemudev.confd xenqemudev
	newinitd "${FILESDIR}"/xen-watchdog.initd xen-watchdog

	if use screen; then
		cat "${FILESDIR}"/xendomains-screen.confd >> "${D}"/etc/conf.d/xendomains || die
		cp "${FILESDIR}"/xen-consoles.logrotate "${D}"/etc/xen/ || die
		keepdir /var/log/xen-consoles
	fi

	# For -static-libs wrt Bug 384355
	if ! use static-libs; then
		rm -f "${D}"/usr/$(get_libdir)/*.a "${D}"/usr/$(get_libdir)/ocaml/*/*.a
	fi

	# for xendomains
	keepdir /etc/xen/auto

	# Remove files failing QA AFTER emake installs them, avoiding seeking absent files
	find "${D}" \( -name openbios-sparc32 -o -name openbios-sparc64 \
		-o -name openbios-ppc -o -name palcode-clipper \) -delete || die

	keepdir /var/lib/xen/dump
	keepdir /var/lib/xen/xenpaging
	keepdir /var/lib/xenstored
	keepdir /var/log/xen

	if use python; then
		python_domodule "${S}/tools/libs/stat/bindings/swig/python/xenstat.py"
		python_domodule "${S}/tools/libs/stat/bindings/swig/python/_xenstat.so"
	fi

	python_optimize
}

pkg_postinst() {
	elog "Official Xen Guide and the offical wiki page:"
	elog "https://wiki.gentoo.org/wiki/Xen"
	elog "https://wiki.xen.org/wiki/Main_Page"
	elog ""
	elog "Recommended to utilise the xencommons script to config system at boot"
	elog "Add by use of rc-update on completion of the install"

	if ! use hvm; then
		echo
		elog "HVM (VT-x and AMD-V) support has been disabled. If you need hvm"
		elog "support enable the hvm use flag."
		elog "An x86 or amd64 system is required to build HVM support."
	fi

	if use qemu; then
		elog "The qemu-bridge-helper is renamed to the xen-bridge-helper in the in source"
		elog "build of qemu.  This allows for app-emulation/qemu to be emerged concurrently"
		elog "with the qemu capable xen.  It is up to the user to distinguish between and utilise"
		elog "the qemu-bridge-helper and the xen-bridge-helper. File bugs of any issues that arise"
	fi
}
