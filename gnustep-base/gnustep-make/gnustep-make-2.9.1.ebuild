# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnustep-base prefix toolchain-funcs

DESCRIPTION="GNUstep Makefile Package"
HOMEPAGE="https://gnustep.github.io"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="libobjc2 native-exceptions"

DEPEND="${GNUSTEP_CORE_DEPEND}
	>=dev-build/make-3.75
	libobjc2? ( gnustep-base/libobjc2
		sys-devel/clang:* )
	!libobjc2? ( !!gnustep-base/libobjc2
		|| (
			sys-devel/gcc:*[objc]
			sys-devel/clang:*
		) )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-2.9.0-no_compress_man_pages.patch )

pkg_setup() {
	# Determine libobjc.so to use
	if use libobjc2; then
		libobjc_version=libobjc.so.4
	else
		# Find version in active gcc
		for ver in {2..5};
		do
			if $(tc-getCC) -Werror -Wl,-l:libobjc.so.${ver} -x objective-c \
				- <<<$'int main() {}' -o /dev/null 2> /dev/null;
			then
				libobjc_version=libobjc.so.${ver}
			fi
		done
	fi

	# Stop if we could not get libobjc.so
	if [[ -z ${libobjc_version} ]]; then
		eerror "${P} requires a working Objective-C runtime and a compiler with"
		eerror "Objective-C support. Your current settings lack these requirements"
		if ! use libobjc2;
		then
			eerror "Please switch your active compiler to gcc with USE=objc, or clang"
		fi
		die "Could not find Objective-C runtime"
	fi

	# For existing installations, determine if we will use another libobjc.so
	if has_version gnustep-base/gnustep-make; then
		local current_libobjc="$(awk -F: '/^OBJC_LIB_FLAG/ {print $2}' ${EPREFIX}/usr/share/GNUstep/Makefiles/config.make)"
		# Old installations did not set this explicitely
		: ${current_libobjc:=libobjc.so.2}

		if [[ ${current_libobjc} != ${libobjc_version} ]]; then
			ewarn "Warning: changed libobjc.so version!!"
			ewarn "The libobjc.so version used for gnustep-make has changed"
			ewarn "(either by the libojbc2 use-flag or a GCC upgrade)"
			ewarn "You must rebuild all gnustep packages installed."
			ewarn ""
			ewarn "To do so, please emerge gnustep-base/gnustep-updater and run:"
			ewarn "# gnustep-updater -l"
		fi
	fi

	if use libobjc2; then
		export CC=clang
	fi
}

src_prepare() {
	# Multilib-strict
	sed -e "s#/lib#/$(get_libdir)#" -i FilesystemLayouts/fhs-system || die "sed failed"
	cp "${FILESDIR}"/gnustep-5.{csh,sh} "${T}"/
	eprefixify "${T}"/gnustep-5.{csh,sh}

	default
}

src_configure() {
	econf \
		INSTALL="${EPREFIX}"/usr/bin/install \
		--with-layout=fhs-system \
		--with-config-file="${EPREFIX}"/etc/GNUstep/GNUstep.conf \
		--with-objc-lib-flag=-l:${libobjc_version} \
		$(use_enable native-exceptions native-objc-exceptions)
}

src_compile() {
	emake
	if use doc ; then
		emake -C Documentation
	fi
}

src_install() {
	# Get GNUSTEP_* variables
	. ./GNUstep.conf

	local make_eval
	use debug || make_eval="${make_eval} debug=no"
	make_eval="${make_eval} verbose=yes"

	emake ${make_eval} DESTDIR="${D}" install

	# Copy the documentation
	if use doc ; then
		emake -C Documentation ${make_eval} DESTDIR="${D}" install
	fi

	dodoc FAQ README RELEASENOTES

	exeinto /etc/profile.d
	doexe "${T}"/gnustep-?.sh
	doexe "${T}"/gnustep-?.csh
}

pkg_postinst() {
	# Warn about new layout if old GNUstep directory is still here
	if [ -e /usr/GNUstep/System ]; then
		ewarn "Old layout directory detected (/usr/GNUstep/System)"
		ewarn "Gentoo has switched to FHS layout for GNUstep packages"
		ewarn "You must first update the configuration files from this package,"
		ewarn "then remerge all packages still installed with the old layout"
		ewarn "You can use gnustep-base/gnustep-updater for this task"
	fi
}
