# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic fortran-2 multilib toolchain-funcs python-single-r1

DESCRIPTION="Message-passing parallel language and runtime system"
HOMEPAGE="http://charm.cs.uiuc.edu/"
SRC_URI="http://charm.cs.uiuc.edu/distrib/${P}.tar.gz"

LICENSE="charm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="charmdebug charmtracing charmproduction cmkopt doc examples mlogft mpi numa smp static-libs syncft tcp"

RDEPEND="mpi? ( virtual/mpi )"
DEPEND="
	${RDEPEND}
	doc? (
		>=app-text/poppler-0.12.3-r3[utils]
		dev-tex/latex2html
		virtual/tex-base
		>=dev-python/beautifulsoup-4[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		media-libs/netpbm
		${PYTHON_DEPS}
	)"

REQUIRED_USE="
	doc? ( ${PYTHON_REQUIRED_USE} )
	cmkopt? ( !charmdebug !charmtracing )
	charmproduction? ( !charmdebug !charmtracing )"

FORTRAN_STANDARD="90"

get_opts() {
	local CHARM_OPTS

	# TCP instead of default UDP for socket comunication
	# protocol
	CHARM_OPTS+="$(usex tcp ' tcp' '')"

	# enable direct SMP support using shared memory
	CHARM_OPTS+="$(usex smp ' smp' '')"

	CHARM_OPTS+="$(usex mlogft ' mlogft' '')"
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
	echo $CHARM_OPTS
}

src_prepare() {
	sed \
		-e "/CMK_CF90/s:f90:$(usex mpi "mpif90" "$(tc-getFC)"):g" \
		-e "/CMK_CXX/s:g++:$(usex mpi "mpic++" "$(tc-getCXX)"):g" \
		-e "/CMK_CC/s:gcc:$(usex mpi "mpicc" "$(tc-getCC)"):g" \
		-e '/CMK_F90_MODINC/s:-p:-I:g' \
		-e "/CMK_LD/s:\"$: ${LDFLAGS} \":g" \
		-i src/arch/$(usex mpi "mpi" "net")-linux*/*sh || die

	sed \
		-e "s:-o conv-cpm:${LDFLAGS} &:g" \
		-e "s:-o charmxi:${LDFLAGS} &:g" \
		-e "s:-o charmrun-silent:${LDFLAGS} &:g" \
		-e "s:-o charmrun-notify:${LDFLAGS} &:g" \
		-e "s:-o charmrun:${LDFLAGS} &:g" \
		-e "s:-o charmd_faceless:${LDFLAGS} &:g" \
		-e "s:-o charmd:${LDFLAGS} &:g" \
		-i \
		src/scripts/Makefile \
		src/arch/net/charmrun/Makefile || die

	# CMK optimization
	use cmkopt && append-cppflags -DCMK_OPTIMIZE=1

	# Fix QA notice. Filed report with upstream.
	append-cflags -DALLOCA_H

	epatch "${FILESDIR}/charm-6.5.1-cleanup-config.patch"
	epatch "${FILESDIR}/charm-6.5.1-CkReductionMgr.patch"
	epatch "${FILESDIR}/charm-6.5.1-fix-string-parsing.patch"
	epatch "${FILESDIR}/charm-6.5.1-fix-navmenuGenerator.patch"
	epatch "${FILESDIR}/charm-6.5.1-static-library-fix.patch"
}

src_compile() {
	local mybuildoptions="$(usex mpi "mpi" "net")-linux$(usex amd64 "-amd64" '') $(get_opts) ${MAKEOPTS} -j1 ${CFLAGS}"

	# Build charmm++ first.
	einfo "running ./build charm++ ${mybuildoptions}"
	./build charm++ ${mybuildoptions} || die "Failed to build charm++"

	# make pdf/html docs
	if use doc; then
		python-single-r1_pkg_setup
		python_fix_shebang "${S}/doc"
		einfo "forcing ${EPYTHON}"
		emake -j1 -C doc/charm++
	fi
}

src_test() {
	make -C tests/charm++ test TESTOPTS="++local" || die
}

src_install() {
	# Make charmc play well with gentoo before we move it into /usr/bin. This
	# patch cannot be applied during src_prepare() because the charmc wrapper
	# is used during building.
	epatch "${FILESDIR}/charm-6.5.1-charmc-gentoo.patch"

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
		doins "${i}"
	done

	# Install static libs. Charm has a lot of .o "libs" that it requires at
	# runtime.
	if use static-libs; then
		for i in lib/*.{a,o}; do
			if [[ -L ${i} ]]; then
				i=$(readlink -e "${i}") || die
			fi
			dolib "${i}"
		done
	fi

	# Install shared libs.
	for i in lib_so/*; do
		if [[ -L ${i} ]]; then
			i=$(readlink -e "${i}") || die
		fi
		dolib.so "${i}"
	done

	# Basic docs.
	dodoc CHANGES README

	# Install examples.
	if use examples; then
		find examples/ -name 'Makefile' | xargs sed \
			-r "s:(../)+bin/charmc:/usr/bin/charmc:" -i || \
			die "Failed to fix examples"
		find examples/ -name 'Makefile' | xargs sed \
			-r "s:./charmrun:./charmrun ++local:" -i || \
			die "Failed to fix examples"
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/charm++/*
	fi

	# Install pdf/html docs
	if use doc; then
		cd "${S}/doc/charm++"
		# Install pdfs.
		insinto /usr/share/doc/${PF}/pdf
		doins  *.pdf
		# Install html.
		docinto html
		dohtml -r manual/*
	fi
}

pkg_postinst() {
	einfo "Please test your charm installation by copying the"
	einfo "content of /usr/share/doc/${PF}/examples to a"
	einfo "temporary location and run 'make test'."
}
