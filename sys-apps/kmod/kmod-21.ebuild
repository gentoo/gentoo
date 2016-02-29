# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit bash-completion-r1 eutils multilib python-r1

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/utils/kernel/${PN}/${PN}.git"
	inherit autotools git-2
else
	SRC_URI="mirror://kernel/linux/utils/kernel/kmod/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"
	inherit libtool
fi

DESCRIPTION="library and tools for managing linux kernel modules"
HOMEPAGE="https://git.kernel.org/?p=utils/kernel/kmod/kmod.git"

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc lzma python static-libs +tools zlib"

# Upstream does not support running the test suite with custom configure flags.
# I was also told that the test suite is intended for kmod developers.
# So we have to restrict it.
# See bug #408915.
RESTRICT="test"

# Block systemd below 217 for -static-nodes-indicate-that-creation-of-static-nodes-.patch
RDEPEND="!sys-apps/module-init-tools
	!sys-apps/modutils
	!<sys-apps/openrc-0.13.8
	!<sys-apps/systemd-216-r3
	lzma? ( >=app-arch/xz-utils-5.0.4-r1 )
	python? ( ${PYTHON_DEPS} )
	zlib? ( >=sys-libs/zlib-1.2.6 )" #427130
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	lzma? ( virtual/pkgconfig )
	python? (
		dev-python/cython[${PYTHON_USEDEP}]
		virtual/pkgconfig
		)
	zlib? ( virtual/pkgconfig )"
if [[ ${PV} == 9999* ]]; then
	DEPEND="${DEPEND}
		dev-libs/libxslt"
fi

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DOCS="NEWS README TODO"

src_prepare() {
	if [ ! -e configure ]; then
		if use doc; then
			gtkdocize --copy --docdir libkmod/docs || die
		else
			touch libkmod/docs/gtk-doc.make
		fi
		eautoreconf
	else
		elibtoolize
	fi

	# Restore possibility of running --enable-static wrt #472608
	sed -i \
		-e '/--enable-static is not supported by kmod/s:as_fn_error:echo:' \
		configure || die
}

src_configure() {
	local myeconfargs=(
		--bindir="${EPREFIX}/bin"
		--with-rootlibdir="${EPREFIX}/$(get_libdir)"
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable tools)
		$(use_enable debug)
		$(use_enable doc gtk-doc)
		$(use_with lzma xz)
		$(use_with zlib)
		--with-bashcompletiondir="$(get_bashcompdir)"
	)

	local ECONF_SOURCE="${S}"

	kmod_configure() {
		mkdir -p "${BUILD_DIR}" || die
		run_in_build_dir econf "${myeconfargs[@]}" "$@"
	}

	BUILD_DIR="${WORKDIR}/build"
	kmod_configure --disable-python

	if use python; then
		python_foreach_impl kmod_configure --enable-python
	fi
}

src_compile() {
	emake -C "${BUILD_DIR}"

	if use python; then
		local native_builddir=${BUILD_DIR}

		python_compile() {
			emake -C "${BUILD_DIR}" -f Makefile -f - python \
				VPATH="${native_builddir}:${S}" \
				native_builddir="${native_builddir}" \
				libkmod_python_kmod_{kmod,list,module,_util}_la_LIBADD='$(PYTHON_LIBS) $(native_builddir)/libkmod/libkmod.la' \
				<<< 'python: $(pkgpyexec_LTLIBRARIES)'
		}

		python_foreach_impl python_compile
	fi
}

src_install() {
	emake -C "${BUILD_DIR}" DESTDIR="${D}" install
	einstalldocs

	if use python; then
		local native_builddir=${BUILD_DIR}

		python_install() {
			emake -C "${BUILD_DIR}" DESTDIR="${D}" \
				VPATH="${native_builddir}:${S}" \
				install-pkgpyexecLTLIBRARIES \
				install-dist_pkgpyexecPYTHON
		}

		python_foreach_impl python_install
	fi

	prune_libtool_files --modules

	if use tools; then
		local bincmd sbincmd
		for sbincmd in depmod insmod lsmod modinfo modprobe rmmod; do
			dosym /bin/kmod /sbin/${sbincmd}
		done

		# These are also usable as normal user
		for bincmd in lsmod modinfo; do
			dosym kmod /bin/${bincmd}
		done
	fi

	cat <<-EOF > "${T}"/usb-load-ehci-first.conf
	softdep uhci_hcd pre: ehci_hcd
	softdep ohci_hcd pre: ehci_hcd
	EOF

	insinto /lib/modprobe.d
	doins "${T}"/usb-load-ehci-first.conf #260139

	newinitd "${FILESDIR}"/kmod-static-nodes-r1 kmod-static-nodes
}

pkg_postinst() {
	if [[ -L ${EROOT%/}/etc/runlevels/boot/static-nodes ]]; then
		ewarn "Removing old conflicting static-nodes init script from the boot runlevel"
		rm -f "${EROOT%/}"/etc/runlevels/boot/static-nodes
	fi

	# Add kmod to the runlevel automatically if this is the first install of this package.
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		if [[ ! -d ${EROOT%/}/etc/runlevels/sysinit ]]; then
			mkdir -p "${EROOT%/}"/etc/runlevels/sysinit
		fi
		if [[ -x ${EROOT%/}/etc/init.d/kmod-static-nodes ]]; then
			ln -s /etc/init.d/kmod-static-nodes "${EROOT%/}"/etc/runlevels/sysinit/kmod-static-nodes
		fi
	fi

	if [[ -e ${EROOT%/}/etc/runlevels/sysinit ]]; then
		if [[ ! -e ${EROOT%/}/etc/runlevels/sysinit/kmod-static-nodes ]]; then
			ewarn
			ewarn "You need to add kmod-static-nodes to the sysinit runlevel for"
			ewarn "kernel modules to have required static nodes!"
			ewarn "Run this command:"
			ewarn "\trc-update add kmod-static-nodes sysinit"
		fi
	fi
}
