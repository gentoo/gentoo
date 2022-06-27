# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils multilib vcs-clean

PATCHSET_VER="1"
MY_P=mercury-srcdist-${PV}

DESCRIPTION="Additional libraries and tools that are not part of the Mercury standard library"
HOMEPAGE="https://www.mercurylang.org/index.html"
SRC_URI="https://dl.mercurylang.org/release/${MY_P}.tar.gz
	https://dev.gentoo.org/~keri/distfiles/mercury-extras/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="cairo examples glut gmp iodbc ncurses odbc opengl ssl tk tommath X xml"
REQUIRED_USE="?? ( odbc iodbc )"

RDEPEND="
	~dev-lang/mercury-${PV}
	cairo? ( >=x11-libs/cairo-1.10.0 )
	gmp? ( dev-libs/gmp:0 )
	glut? ( media-libs/freeglut )
	odbc? ( dev-db/unixODBC )
	iodbc? ( dev-db/libiodbc )
	tommath? ( dev-libs/libtommath )
	ncurses? ( sys-libs/ncurses:= )
	opengl? (
		virtual/opengl
		virtual/glu
	)
	tk? (
		dev-lang/tcl:0
		dev-lang/tk:0
	)
	X? ( x11-libs/libX11 )"

DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}/extras

mercury_pkgs() {
	echo "
		align_right/align_right:bin:
		base64/mercury_base64:lib:
		cgi/mercury_www:lib:
		complex_numbers/complex_numbers:lib:
		$(use ncurses && echo \
			curs/curs:lib:ncurses,panel curses/mcurses:lib:ncurses)
		dynamic_linking/dl:lib:
		error/error:bin:
		fixed/fixed:lib:
		$(use gmp && echo gmp_int/gmp_int:lib:)
		$(use tommath && echo mp_int/mp_int:lib:libtommath)
		$(use X && echo graphics/easyx/easyx:lib:x11)
		$(use cairo && echo graphics/mercury_cairo/mercury_cairo:lib:cairo)
		$(use glut && echo graphics/mercury_glut/mercury_glut:lib:freeglut)
		$(use opengl && echo graphics/mercury_opengl/mercury_opengl:lib:gl,glu)
		$(use tk && echo graphics/mercury_tcltk/mercury_tcltk:lib:tk)
		lex/lex:lib:
		lex/regex:lib:
		moose/moose:bin:
		net/net:lib:
		net/echo:bin:
		$(use ssl && echo mopenssl/mopenssl:lib:openssl)
		$(use odbc && echo odbc/odbc:lib:odbc)
		$(use iodbc && echo odbc/odbc:lib:libiodbc)
		posix/posix:lib:
		$(has_version dev-lang/mercury[trail] && echo \
			references/global:lib:)
		show_ops/show_ops:bin:
		solver_types/library/any:lib:
		$(use xml && echo xml/xml:lib:)"
}

mercury_pkg_setup() {
	mercury_pkg=${1%%:*}
	mercury_pkg_dir=${mercury_pkg%/*}
	mercury_pkg_name=${mercury_pkg##*/}

	mercury_pkg_atts=${1#*:}
	mercury_pkg_type=${mercury_pkg_atts%%:*}
	mercury_pkg_deps=${mercury_pkg_atts#*:}

	cd "${S}"/${mercury_pkg_dir} || die

	echo ">> Preparing Mercury package: ${mercury_pkg}"

	echo "MCFLAGS += --libgrades-exclude java" \
		>> "${S}"/${mercury_pkg_dir}/Mercury.options
	echo "MCFLAGS += --libgrades-exclude csharp" \
		>> "${S}"/${mercury_pkg_dir}/Mercury.options

	if test -n "$mercury_pkg_deps"; then
		echo "EXTRA_CFLAGS += $(pkg-config --cflags ${mercury_pkg_deps/,/ })" \
			>> "${S}"/${mercury_pkg_dir}/Mercury.options
		echo "EXTRA_LDFLAGS += $(pkg-config --libs ${mercury_pkg_deps/,/ })" \
			>> "${S}"/${mercury_pkg_dir}/Mercury.options
	fi

	if test ${mercury_pkg_name} = dl; then
		echo "EXTRA_LDFLAGS += -ldl" >> "${S}"/${mercury_pkg_dir}/Mercury.options
	elif test ${mercury_pkg_name} = gmp_int; then
		echo "EXTRA_LDFLAGS += -lgmp" >> "${S}"/${mercury_pkg_dir}/Mercury.options
	elif test ${mercury_pkg_name} = mercury_tcltk; then
		echo "EXTRA_CFLAGS += -DUSE_INTERP_RESULT" \
			>> "${S}"/${mercury_pkg_dir}/Mercury.options
	elif test ${mercury_pkg_name} = odbc && use odbc; then
		echo "EXTRA_CFLAGS += -DMODBC_UNIX -DMODBC_MYSQL" \
			>> "${S}"/${mercury_pkg_dir}/Mercury.options
	elif test ${mercury_pkg_name} = odbc && use iodbc; then
		echo "EXTRA_CFLAGS += -DMODBC_IODBC -DMODBC_MYSQL" \
			>> "${S}"/${mercury_pkg_dir}/Mercury.options
	fi
}

mercury_pkg_compile() {
	mercury_pkg=${1%%:*}
	mercury_pkg_dir=${mercury_pkg%/*}
	mercury_pkg_name=${mercury_pkg##*/}

	mercury_pkg_atts=${1#*:}
	mercury_pkg_type=${mercury_pkg_atts%:*}

	cd "${S}"/${mercury_pkg_dir} || die

	echo ">> Compiling Mercury package: ${mercury_pkg}"

	if test "${mercury_pkg_type}" = "bin"; then
		mercury_mmc_target=${mercury_pkg_name}
	else
		mercury_mmc_target=lib${mercury_pkg_name}
	fi

	mmc -f *.m || die "mmc -f .m failed"

	mmc \
		--make \
		--verbose-commands \
		--no-strip \
		--cflags "${CFLAGS}" \
		--ld-flags "${LDFLAGS}" \
		--ld-libflags "${LDFLAGS}" \
		${mercury_mmc_target} || die "mmc ${mercury_mmc_target} failed"
}

mercury_pkg_install() {
	mercury_pkg=${1%%:*}
	mercury_pkg_dir=${mercury_pkg%/*}
	mercury_pkg_name=${mercury_pkg##*/}

	mercury_pkg_atts=${1#*:}
	mercury_pkg_type=${mercury_pkg_atts%:*}

	cd "${S}"/${mercury_pkg_dir} || die

	echo ">> Installing Mercury package: ${mercury_pkg}"

	if test "${mercury_pkg_type}" = "bin"; then
		into /usr/$(get_libdir)/mercury/extras
		dobin ${mercury_pkg_name}
	else
		mmc \
			--make \
			--verbose-commands \
			--no-strip \
			--cflags "${CFLAGS}" \
			--ld-flags "${LDFLAGS}" \
			--ld-libflags "${LDFLAGS}" \
			--install-prefix "${D}/usr/$(get_libdir)/mercury/extras" \
			lib${mercury_pkg_name}.install || die "mmc lib${mercury_pkg_name}.install failed"
	fi
}

src_prepare() {
	cd "${WORKDIR}"/${MY_P}
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		eapply "${WORKDIR}"/${PV}
	fi
	eapply_user

	cd "${S}"
	for mercury_pkg in $(mercury_pkgs); do
		mercury_pkg_setup ${mercury_pkg}
	done

	cp "${S}"/net/*.m "${S}"/mopenssl/ || die
}

src_compile() {
	for mercury_pkg in $(mercury_pkgs); do
		mercury_pkg_compile ${mercury_pkg}
	done
}

src_install() {
	for mercury_pkg in $(mercury_pkgs); do
		mercury_pkg_install ${mercury_pkg}
	done

	cd "${S}"
	dodoc README.md

	if use examples; then
		docinto samples/cgi
		dodoc cgi/form_test.m

		docinto samples/complex_numbers
		dodoc complex_numbers/samples/*.m

		if use ncurses; then
			docinto samples/curs
			dodoc curs/samples/*.m

			docinto samples/curses
			dodoc curses/sample/*.m
		fi

		docinto samples/dynamic_linking
		dodoc dynamic_linking/{hello,dl_test}.m

		docinto samples/gator
		dodoc -r gator/*

		if use gmp; then
			docinto samples/gmp_int
			dodoc gmp_int/gmp_int_test.m
		fi

		if use tommath; then
			docinto samples/mp_int
			dodoc mp_int/mp_int_test.m
		fi

		if use X; then
			docinto samples/graphics
			dodoc graphics/easyx/samples/*.m
		fi

		if use glut && use opengl; then
			docinto samples/graphics
			dodoc graphics/samples/gears/*.m
			dodoc graphics/samples/maze/*.m
		fi

		if use tk; then
			docinto samples/graphics
			dodoc graphics/samples/calc/*.m
		fi

		docinto samples/lex
		dodoc lex/samples/*.m

		docinto samples/log4m
		dodoc log4m/*.m

		docinto samples/monte
		dodoc monte/*.m

		docinto samples/moose
		dodoc moose/samples/*

		docinto samples/net
		dodoc net/test_lookups.m

		if use odbc || use iodbc; then
			docinto samples/odbc
			dodoc odbc/odbc_test.m
		fi

		docinto samples/posix
		dodoc posix/samples/*.m

		docinto samples/random
		dodoc random/*.m

		if has_version dev-lang/mercury[trail]; then
			docinto samples/references
			dodoc references/samples/*.m

			docinto samples/trail
			dodoc trail/*.m
		fi

		if use xml; then
			docinto samples/xml
			dodoc xml/tryit.m
			dodoc xml/samples/*
			dodoc xml_stylesheets/*.xsl
		fi

		ecvs_clean
	fi
}
