# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='ncurses,xml,threads'

inherit eutils bash-completion-r1 flag-o-matic multilib python-single-r1 toolchain-funcs versionator

MY_PV=${PV/_/-}
MAJOR_V="$(get_version_component_range 1-2)"

if [[ $PV == *9999 ]]; then
	inherit git-r3
	KEYWORDS=""
	REPO="xen.git"
	EGIT_REPO_URI="git://xenbits.xen.org/${REPO}"
	S="${WORKDIR}/${REPO}"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	UPSTREAM_VER=0
	SECURITY_VER=12
	# xen-tools's gentoo patches tarball
	GENTOO_VER=6
	# xen-tools's gentoo patches version which apply to this specific ebuild
	GENTOO_GPV=0
	# xen-tools ovmf's patches
	OVMF_VER=2

	SEABIOS_VER=1.8.2
	# OVMF upstream 52a99493cce88a9d4ec8a02d7f1bd1a1001ce60d
	OVMF_PV=20151110

	[[ -n ${UPSTREAM_VER} ]] && \
		UPSTREAM_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${P/-tools/}-upstream-patches-${UPSTREAM_VER}.tar.xz"
	[[ -n ${SECURITY_VER} ]] && \
		SECURITY_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${PN/-tools}-security-patches-${SECURITY_VER}.tar.xz"
	[[ -n ${GENTOO_VER} ]] && \
		GENTOO_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${PN/-tools}-gentoo-patches-${GENTOO_VER}.tar.xz"
	[[ -n ${OVMF_VER} ]] && \
		OVMF_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${PN/-tools}-ovmf-patches-${OVMF_VER}.tar.xz"

	SRC_URI="http://bits.xensource.com/oss-xen/release/${MY_PV}/xen-${MY_PV}.tar.gz
	http://code.coreboot.org/p/seabios/downloads/get/seabios-${SEABIOS_VER}.tar.gz
	https://dev.gentoo.org/~dlan/distfiles/seabios-${SEABIOS_VER}.tar.gz
	ovmf? ( https://dev.gentoo.org/~dlan/distfiles/ovmf-${OVMF_PV}.tar.bz2
		${OVMF_PATCHSET_URI} )
	${UPSTREAM_PATCHSET_URI}
	${SECURITY_PATCHSET_URI}
	${GENTOO_PATCHSET_URI}"

	S="${WORKDIR}/xen-${MY_PV}"
fi

DESCRIPTION="Xen tools including QEMU and xl"
HOMEPAGE="http://xen.org/"
DOCS=( README docs/README.xen-bugtool )

LICENSE="GPL-2"
SLOT="0/${MAJOR_V}"
# Inclusion of IUSE ocaml on stabalizing requires maintainer of ocaml to (get off his hands and) make
# >=dev-lang/ocaml-4 stable
# Masked in profiles/eapi-5-files instead
IUSE="api custom-cflags debug doc flask hvm qemu ocaml ovmf +qemu-traditional +pam python pygrub screen sdl static-libs system-qemu system-seabios"

REQUIRED_USE="hvm? ( || ( qemu system-qemu ) )
	${PYTHON_REQUIRED_USE}
	pygrub? ( python )
	ovmf? ( hvm )
	qemu? ( !system-qemu )"

COMMON_DEPEND="
	dev-libs/lzo:2
	dev-libs/glib:2
	dev-libs/yajl
	dev-libs/libaio
	dev-libs/libgcrypt:0
	sys-libs/zlib
"

DEPEND="${COMMON_DEPEND}
	dev-python/lxml[${PYTHON_USEDEP}]
	x86? ( sys-devel/dev86
		sys-power/iasl )
	pam? ( dev-python/pypam[${PYTHON_USEDEP}] )
	${PYTHON_DEPS}
	api? ( dev-libs/libxml2
		net-misc/curl )
	ovmf? ( $(python_gen_impl_dep sqlite) )
	!amd64? ( >=sys-apps/dtc-1.4.0 )
	amd64? ( sys-devel/bin86
		system-seabios? ( sys-firmware/seabios )
		sys-firmware/ipxe
		sys-devel/dev86
		sys-power/iasl )
	dev-lang/perl
	app-misc/pax-utils
	doc? (
		app-doc/doxygen
		dev-python/markdown[${PYTHON_USEDEP}]
		dev-tex/latex2html[png,gif]
		media-gfx/graphviz
		dev-tex/xcolor
		media-gfx/transfig
		dev-texlive/texlive-latexextra
		virtual/latex-base
		dev-tex/latexmk
		dev-texlive/texlive-latex
		dev-texlive/texlive-pictures
		dev-texlive/texlive-latexrecommended
	)
	hvm? ( x11-proto/xproto
		!net-libs/libiscsi )
	qemu? (
		x11-libs/pixman
		sdl? ( media-libs/libsdl[X] )
	)
	system-qemu? ( app-emulation/qemu[xen] )
	ocaml? ( dev-ml/findlib
		>=dev-lang/ocaml-4 )"

RDEPEND="${COMMON_DEPEND}
	sys-apps/iproute2[-minimal]
	net-misc/bridge-utils
	screen? (
		app-misc/screen
		app-admin/logrotate
	)"

# hvmloader is used to bootstrap a fully virtualized kernel
# Approved by QA team in bug #144032
QA_WX_LOAD="usr/lib/xen/boot/hvmloader
	usr/share/qemu-xen/qemu/s390-ccw.img"

RESTRICT="test"

pkg_setup() {
	python_setup
	export "CONFIG_LOMOUNT=y"

	#bug 522642, disable compile tools/tests
	export "CONFIG_TESTS=n"

	if has_version dev-libs/libgcrypt:0; then
		export "CONFIG_GCRYPT=y"
	fi

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
	# Upstream's patchset
	if [[ -n ${UPSTREAM_VER} ]]; then
		einfo "Try to apply Xen Upstream patch set"
		EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" \
		EPATCH_OPTS="-p1" \
			epatch "${WORKDIR}"/patches-upstream
	fi

	# Security patchset
	if [[ -n ${SECURITY_VER} ]]; then
	einfo "Try to apply Xen Security patch set"
		# apply main xen patches
		# Two parallel systems, both work side by side
		# Over time they may concdense into one. This will suffice for now
		EPATCH_SUFFIX="patch"
		EPATCH_FORCE="yes"

		source "${WORKDIR}"/patches-security/${PV}.conf

		for i in ${XEN_SECURITY_MAIN}; do
			epatch "${WORKDIR}"/patches-security/xen/$i
		done

		# apply qemu-xen/upstream patches
		pushd "${S}"/tools/qemu-xen/ > /dev/null
		for i in ${XEN_SECURITY_QEMUU}; do
			epatch "${WORKDIR}"/patches-security/qemuu/$i
		done
		popd > /dev/null

		# apply qemu-traditional patches
		pushd "${S}"/tools/qemu-xen-traditional/ > /dev/null
		for i in ${XEN_SECURITY_QEMUT}; do
			epatch "${WORKDIR}"/patches-security/qemut/$i
		done
		popd > /dev/null
	fi

	# move before Gentoo patch, one patch should apply to seabios, to fix gcc-4.5.x build err
	mv ../seabios-${SEABIOS_VER} tools/firmware/seabios-dir-remote || die
	pushd tools/firmware/ > /dev/null
	ln -s seabios-dir-remote seabios-dir || die
	popd > /dev/null

	# Gentoo's patchset
	if [[ -n ${GENTOO_VER} && -n ${GENTOO_GPV} ]]; then
		einfo "Try to apply Gentoo specific patch set"
		source "${FILESDIR}"/gentoo-patches.conf
		_gpv=_gpv_${PN/-/_}_${PV//./}_${GENTOO_GPV}
		for i in ${!_gpv}; do
			EPATCH_SUFFIX="patch" \
			EPATCH_FORCE="yes" \
				epatch "${WORKDIR}"/patches-gentoo/$i
		done
	fi

	# Ovmf's patchset
	if use ovmf; then
		if [[ -n ${OVMF_VER} ]];then
			einfo "Try to apply Ovmf patch set"
			pushd "${WORKDIR}"/ovmf-*/ > /dev/null
			EPATCH_SUFFIX="patch" \
			EPATCH_FORCE="yes" \
			EPATCH_OPTS="-p1" \
				epatch "${WORKDIR}"/patches-ovmf
			popd > /dev/null
		fi
		mv ../ovmf-${OVMF_PV} tools/firmware/ovmf-dir-remote || die
	fi

	mv tools/qemu-xen/qemu-bridge-helper.c tools/qemu-xen/xen-bridge-helper.c || die

	# Fix texi2html build error with new texi2html, qemu.doc.html
	sed -i -e "/texi2html -monolithic/s/-number//" tools/qemu-xen-traditional/Makefile || die

	use api   || sed -e "/SUBDIRS-\$(LIBXENAPI_BINDINGS) += libxen/d" -i tools/Makefile || die
	sed -e 's:$(MAKE) PYTHON=$(PYTHON) subdirs-$@:LC_ALL=C "$(MAKE)" PYTHON=$(PYTHON) subdirs-$@:' \
		 -i tools/firmware/Makefile || die

	# Drop .config, fixes to gcc-4.6
	sed -e '/-include $(XEN_ROOT)\/.config/d' -i Config.mk || die "Couldn't	drop"

	# if the user *really* wants to use their own custom-cflags, let them
	if use custom-cflags; then
		einfo "User wants their own CFLAGS - removing defaults"

		# try and remove all the default cflags
		find "${S}" \( -name Makefile -o -name Rules.mk -o -name Config.mk \) \
			-exec sed \
				-e 's/CFLAGS\(.*\)=\(.*\)-O3\(.*\)/CFLAGS\1=\2\3/' \
				-e 's/CFLAGS\(.*\)=\(.*\)-march=i686\(.*\)/CFLAGS\1=\2\3/' \
				-e 's/CFLAGS\(.*\)=\(.*\)-fomit-frame-pointer\(.*\)/CFLAGS\1=\2\3/' \
				-e 's/CFLAGS\(.*\)=\(.*\)-g3*\s\(.*\)/CFLAGS\1=\2 \3/' \
				-e 's/CFLAGS\(.*\)=\(.*\)-O2\(.*\)/CFLAGS\1=\2\3/' \
				-i {} + || die "failed to re-set custom-cflags"
	else
		unset CFLAGS
		unset LDFLAGS
		unset ASFLAGS
		unset CPPFLAGS
	fi

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
		sed -e "s:install-tools\: tools/qemu-xen-traditional-dir:install-tools\: :g" -i Makefile || die
	fi

	# Reset bash completion dir; Bug 472438
	sed -e "s:^BASH_COMPLETION_DIR ?= \$(CONFIG_DIR)/bash_completion.d:BASH_COMPLETION_DIR ?= $(get_bashcompdir):" \
		-i Config.mk || die
	sed -i -e "/bash-completion/s/xl\.sh/xl/g" tools/libxl/Makefile || die

	# xencommons, Bug #492332, sed lighter weight than patching
	sed -e 's:\$QEMU_XEN -xen-domid:test -e "\$QEMU_XEN" \&\& &:' \
		-i tools/hotplug/Linux/init.d/xencommons.in || die

	# respect multilib, usr/lib/libcacard.so.0.0.0
	sed -e "/^libdir=/s/\/lib/\/$(get_libdir)/" \
		-i tools/qemu-xen/configure || die

	#bug 518136, don't build 32bit exactuable for nomultilib profile
	if [[ "${ARCH}" == 'amd64' ]] && ! has_multilib_profile; then
		sed -i -e "/x86_emulator/d" tools/tests/Makefile || die
	fi

	# use /var instead of /var/lib, consistat with previous ebuild
	sed -i -e   "/XEN_LOCK_DIR=/s/\$localstatedir/\/var/g" \
		m4/paths.m4 configure tools/configure || die
	# use /run instead of /var/run
	sed -i -e   "/XEN_RUN_DIR=/s/\$localstatedir//g" \
		m4/paths.m4 configure tools/configure || die

	# uncomment lines in xl.conf
	sed -e 's:^#autoballoon=:autoballoon=:' \
		-e 's:^#lockfile=:lockfile=:' \
		-e 's:^#vif.default.script=:vif.default.script=:' \
		-i tools/examples/xl.conf  || die

	# Bug #575868 converted to a sed statement, typo of one char
	sed -e "s:granter’s:granter's:" -i xen/include/public/grant_table.h || die

	epatch_user
}

src_configure() {
	local myconf="--prefix=${PREFIX}/usr \
		--libdir=${PREFIX}/usr/$(get_libdir) \
		--libexecdir=${PREFIX}/usr/libexec \
		--disable-werror \
		--disable-xen \
		--enable-tools \
		--enable-docs \
		$(use_with system-qemu) \
		$(use_enable pam) \
		$(use_enable api xenapi) \
		$(use_enable ovmf) \
		$(use_enable ocaml ocamltools) \
		--with-xenstored=$(usex ocaml 'oxenstored' 'xenstored') \
		"

	use system-seabios && myconf+=" --with-system-seabios=/usr/share/seabios/bios.bin"
	use qemu || myconf+=" --with-system-qemu"
	use amd64 && myconf+=" $(use_enable qemu-traditional)"
	econf ${myconf}
}

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	local myopt
	use debug && myopt="${myopt} debug=y"

	if test-flag-CC -fno-strict-overflow; then
		append-flags -fno-strict-overflow
	fi

	emake V=1 CC="$(tc-getCC)" LD="$(tc-getLD)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" -C tools ${myopt}

	use doc && emake -C docs txt html
	emake -C docs man-pages
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

	# Fix the remaining Python shebangs.
	python_fix_shebang "${D}"

	# Remove RedHat-specific stuff
	rm -rf "${D}"tmp || die

	if use doc; then
		emake DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" install-docs

		dohtml -r docs/
		docinto pdf
		dodoc ${DOCS[@]}
		[ -d "${D}"/usr/share/doc/xen ] && mv "${D}"/usr/share/doc/xen/* "${D}"/usr/share/doc/${PF}/html
	fi

	rm -rf "${D}"/usr/share/doc/xen/
	doman docs/man?/*

	newconfd "${FILESDIR}"/xendomains.confd xendomains
	newconfd "${FILESDIR}"/xenstored.confd xenstored
	newconfd "${FILESDIR}"/xenconsoled.confd xenconsoled
	newinitd "${FILESDIR}"/xendomains.initd-r2 xendomains
	newinitd "${FILESDIR}"/xenstored.initd xenstored
	newinitd "${FILESDIR}"/xenconsoled.initd xenconsoled
	newinitd "${FILESDIR}"/xencommons.initd xencommons
	newconfd "${FILESDIR}"/xencommons.confd xencommons
	newinitd "${FILESDIR}"/xenqemudev.initd xenqemudev
	newconfd "${FILESDIR}"/xenqemudev.confd xenqemudev

	if use screen; then
		cat "${FILESDIR}"/xendomains-screen.confd >> "${D}"/etc/conf.d/xendomains || die
		cp "${FILESDIR}"/xen-consoles.logrotate "${D}"/etc/xen/ || die
		keepdir /var/log/xen-consoles
	fi

	# For -static-libs wrt Bug 384355
	if ! use static-libs; then
		rm -f "${D}"usr/$(get_libdir)/*.a "${D}"usr/$(get_libdir)/ocaml/*/*.a
	fi

	# for xendomains
	keepdir /etc/xen/auto

	# Remove files failing QA AFTER emake installs them, avoiding seeking absent files
	find "${D}" \( -name openbios-sparc32 -o -name openbios-sparc64 \
		-o -name openbios-ppc -o -name palcode-clipper \) -delete || die
}

pkg_postinst() {
	elog "Official Xen Guide and the offical wiki page:"
	elog "https://wiki.gentoo.org/wiki/Xen"
	elog "http://wiki.xen.org/wiki/Main_Page"
	elog ""
	elog "Recommended to utilise the xencommons script to config sytem At boot"
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
		elog "the qemu-bridge-helper and the xen-bridge-helper.  File bugs of any issues that arise"
	fi
}
