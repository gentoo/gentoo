# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_STANDARD="90"

inherit flag-o-matic fortran-2 multiprocessing toolchain-funcs

DESCRIPTION="Message-passing parallel language and runtime system"
HOMEPAGE="http://charm.cs.uiuc.edu/"
SRC_URI="http://charm.cs.uiuc.edu/distrib/${P}.tar.gz"
S="${WORKDIR}"/${PN}-v${PV}

LICENSE="charm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="charmdebug charmtracing charmproduction cmkopt examples mpi ampi numa smp static-libs syncft tcp"

RDEPEND="mpi? ( virtual/mpi )"
DEPEND="
	${RDEPEND}
	net-libs/libtirpc"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="
	cmkopt? ( !charmdebug !charmtracing )
	charmproduction? ( !charmdebug !charmtracing )
	mpi? ( !tcp )"

get_opts() {
	local CHARM_OPTS

	# TCP instead of default UDP for socket comunication
	# protocol
	CHARM_OPTS+="$(usex tcp ' tcp' '')"

	# enable direct SMP support using shared memory
	CHARM_OPTS+="$(usex smp ' smp' '')"

	CHARM_OPTS+="$(usex syncft ' syncft' '')"

	# Build shared libraries by default.
	CHARM_OPTS+=" --build-shared"

	if use charmproduction; then
		CHARM_OPTS+=" --with-production"
	else
		if use charmdebug; then
			CHARM_OPTS+=" --enable-charmdebug"
		fi

		if use charmtracing; then
			CHARM_OPTS+=" --enable-tracing --enable-tracing-commthread"
		fi
	fi

	CHARM_OPTS+="$(usex numa ' --with-numa' '')"

	echo ${CHARM_OPTS}
}

src_prepare() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/863725
	# https://github.com/UIUC-PPL/charm/issues/3789
	#
	# Do not trust with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	append-cppflags $($(tc-getPKG_CONFIG) --cflags libtirpc)

	sed \
		-e "/CMK_CF77/s|[fg]77|$(usex mpi "mpif90" "$(tc-getF77)") ${FCFLAGS}|g" \
		-e "/CMK_CF90/s|f95|$(usex mpi "mpif90" "$(tc-getFC)") ${FCFLAGS}|g" \
		-e "/CMK_CF90/s|\`which f90.*$||g" \
		-e "/CMK_CXX/s|g++|$(usex mpi "mpic++" "$(tc-getCXX)") ${CPPFLAGS}|g" \
		-e "/CMK_CC/s|gcc|$(usex mpi "mpicc" "$(tc-getCC)") ${CPPFLAGS}|g" \
		-e '/CMK_F90_MODINC/s|-p|-I|g' \
		-i src/arch/$(usex mpi "mpi" "net")*-linux*/*sh || die

	sed \
		-e "/CMK_CC='gcc'/s|gcc|$(usex mpi "mpicc" "$(tc-getCC)")|" \
		-e "/CMK_CXX='g++'/s|g++|$(usex mpi "mpic++" "$(tc-getCXX)")|" \
		-e "/CMK_LDXX='g++'/s|g++|$(usex mpi "mpic++" "$(tc-getCXX)")|" \
		-e "s|CMK_CF90=\$(which .*)|CMK_CF90=\$(which $(usex mpi "mpif90" "$(tc-getFC)"))|" \
		-e "/-z \$CMK_CF90/d" \
		-e "/F90DIR/s|gfortran|$(usex mpi "mpif90" "$(tc-getFC)") ${FCFLAGS}|g" \
		-e "/f95target/s|gfortran|$(usex mpi "mpif90" "$(tc-getFC)") ${FCFLAGS}|g" \
		-e "/f95version/s|gfortran|$(usex mpi "mpif90" "$(tc-getFC)") ${FCFLAGS}|g" \
		-i src/arch/common/*.sh || die

	sed \
		-e "/^CHARMC/s|$| ${CPPFLAGS}|g" \
		-i \
		src/scripts/Makefile \
		src/util/charmrun-src/Makefile || die

	# Use toolchain nm
	sed -i \
		-e "/CMK_NM=/s|nm|$(tc-getNM)|" \
		src/arch/*/*.sh \
		src/scripts/conv-config.sh \
		|| die

	sed -i \
		-e "s|^OPTS=\"\"|OPTS=\"-c++-option ${CXXFLAGS} -cc-option ${CFLAGS}\"|" \
		build || die

	eapply "${FILESDIR}"/${P}-cxxflags.patch \
		"${FILESDIR}"/${PN}-6.9.0-soname.patch

	# CMK optimization
	use cmkopt && append-cppflags -DCMK_OPTIMIZE=1

	# Fix QA notice. Filed report with upstream.
	append-cflags -DALLOCA_H

	eapply_user
}

src_compile() {
	local build_version="$(usex mpi "mpi" "netlrts")-linux$(usex amd64 "-x86_64" '')"
	local build_options="$(get_opts)"
	#build only accepts -j from MAKEOPTS
	local build_commandline="${build_version} ${build_options} -j$(makeopts_jobs) -ld-option ${LDFLAGS}"

	# Build charmm++ first.
	einfo "running ./build charm++ ${build_commandline}"
	GENTOO_CFLAGS="${CFLAGS}" \
		GENTOO_CXXFLAGS="${CXXFLAGS}" \
		./build charm++ ${build_commandline} || die "Failed to build charm++"

	if use ampi; then
		einfo "running ./build AMPI ${build_commandline}"
		./build AMPI ${build_commandline} || die "Failed to build charm++"
	fi
}

src_test() {
	make -C tests/charm++ test TESTOPTS="++local" || die
}

src_install() {
	# Make charmc play well with gentoo before we move it into /usr/bin. This
	# patch cannot be applied during src_prepare() because the charmc wrapper
	# is used during building.
	eapply "${FILESDIR}/charm-6.10.2-charmc-gentoo.patch"

	sed -e "s|gentoo-include|${P}|" \
		-e "s|gentoo-libdir|$(get_libdir)|g" \
		-e "s|VERSION|${P}/VERSION|" \
		-i ./src/scripts/charmc || die "failed patching charmc script"

	# In the following, some of the files are symlinks to ../tmp which we need
	# to dereference first (see bug 432834).

	local i

	# Install binaries.
	for i in bin/*; do
		if [[ -L ${i} ]]; then
			i=$(readlink -e "${i}") || die
		fi
		dobin "${i}"
	done

	# Install headers.
	insinto /usr/include/${P}
	for i in include/*; do
		if [[ -L ${i} ]]; then
			i=$(readlink -e "${i}") || die
		fi
		doins -r "${i}"
	done

	# Install libs incl. charm objects
	for i in lib*/*.{so,a}; do
		[[ ${i} = *.a ]] && ! use static-libs && continue
		if [[ -L ${i} ]]; then
			i=$(readlink -e "${i}") || die
		fi
		[[ -s $i ]] || continue
		[[ ${i} = *.so ]] && dolib.so "${i}" || dolib.a "${i}"
	done
	rm -f "${ED}"/usr/$(get_libdir)/libthreads-fibers.so* || die

	# Install examples.
	if use examples; then
		find examples/ -name 'Makefile' | xargs sed \
			-r "s|(../)+bin/charmc|/usr/bin/charmc|" -i || \
			die "Failed to fix examples"
		find examples/ -name 'Makefile' | xargs sed \
			-r "s|./charmrun|./charmrun ++local|" -i || \
			die "Failed to fix examples"
		docinto examples
		dodoc -r examples/charm++/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	einfo "Please test your charm installation by copying the"
	einfo "content of /usr/share/doc/${PF}/examples to a"
	einfo "temporary location and run 'make test'."
}
