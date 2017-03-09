# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

MY_PV=$(delete_all_version_separators "${PV}")
MY_P="${PN}${MY_PV}"

DESCRIPTION="An Automated Theorem Prover for First-Order Logic with Equality"
HOMEPAGE="http://www.spass-prover.org/"
SRC_URI="http://www.spass-prover.org/download/sources/${MY_P}.tgz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="isabelle"

RDEPEND="isabelle? (
			sci-mathematics/isabelle:=
		)"
DEPEND="${RDEPEND}"

src_unpack() {
	mkdir -p "${P}" || die
	cd "${S}" || die
	unpack "${MY_P}.tgz"
}

src_compile() {
	einfo "generating parsers"
	bison -d -p pro_ -o proparser.c proparser.y || die
	bison -d -p tptp_ -o tptpparser.c tptpparser.y || die
	bison -d -p ia_ -o iaparser.c iaparser.y || die

	einfo "generating lexers"
	flex -Ppro_ -o proscanner.c proscanner.l || die
	flex -Ptptp_ -o tptpscanner.c tptpscanner.l || die
	flex -Pia_ -o iascanner.c iascanner.l || die

	einfo "compiling sources"
	local x
	for x in *.c
	do
		$(tc-getCC) \
			${CPPFLAGS} ${CFLAGS} \
			-c -o ${x/.c/.o} ${x} || die "compile ${x} failed"
	done

	einfo "linking tptp2dfg"
	$(tc-getCC) \
		${LDFLAGS} -o tptp2dfg \
		array.o clause.o cmdline.o context.o description.o dfg_diagnostic.o \
		dfg_string_table.o dfg_token.o dfgparser.o dfglexer.o  \
		tptpparser.o tptpscanner.o eml.o flags.o foldfg.o hashmap.o kbo.o \
		list.o memory.o misc.o order.o rpos.o sharing.o st.o stack.o \
		strings.o subst.o symbol.o term.o unify.o tptp2dfg.o -lm \
		|| die "link tptp2dfg failed"

	einfo "linking dfg2ascii"
	$(tc-getCC) \
		${LDFLAGS} -o dfg2ascii \
		array.o clause.o cmdline.o context.o description.o dfg_diagnostic.o \
		dfg_string_table.o dfg_token.o dfgparser.o dfglexer.o \
		tptpparser.o tptpscanner.o eml.o flags.o foldfg.o hashmap.o kbo.o \
		list.o memory.o misc.o order.o rpos.o sharing.o st.o stack.o \
		strings.o subst.o symbol.o term.o unify.o dfg2ascii.o -lm \
		|| die "link dfg2ascii failed"

	einfo "linking dfg2dfg"
	$(tc-getCC) \
		${LDFLAGS} -o dfg2dfg \
		array.o clause.o cmdline.o context.o description.o dfg_diagnostic.o \
		dfg_string_table.o dfg_token.o dfgparser.o dfglexer.o \
		tptpparser.o tptpscanner.o eml.o flags.o foldfg.o hashmap.o kbo.o \
		list.o memory.o misc.o order.o rpos.o sharing.o st.o stack.o \
		strings.o subst.o symbol.o term.o unify.o approx.o dfg2dfg.o -lm \
		|| die "link dfg2dfg failed"

	einfo "linking SPASS"
	$(tc-getCC) \
		${LDFLAGS} -o SPASS \
		array.o clause.o cmdline.o context.o description.o dfg_diagnostic.o \
		dfg_string_table.o dfg_token.o dfgparser.o dfglexer.o \
		tptpparser.o tptpscanner.o eml.o flags.o foldfg.o hashmap.o kbo.o \
		list.o memory.o misc.o order.o rpos.o sharing.o st.o stack.o \
		strings.o subst.o symbol.o term.o unify.o analyze.o clock.o \
		closure.o cnf.o component.o condensing.o defs.o doc-proof.o graph.o \
		hash.o hasharray.o iaparser.o iascanner.o partition.o proofcheck.o \
		ras.o renaming.o resolution.o rules-inf.o rules-red.o rules-sort.o \
		rules-split.o rules-ur.o search.o sort.o subsumption.o table.o \
		tableau.o terminator.o top.o vector.o -lm \
		|| die "link SPASS failed"
}

src_install() {
	exeinto /usr/bin
	local x
	for x in tptp2dfg dfg2ascii dfg2dfg SPASS
	do
		doexe ${x}
	done

	if use isabelle; then
		ewarn "All open source versions of spass are broken with Isabelle 2016.1"
		ISABELLE_HOME="$(isabelle getenv ISABELLE_HOME | cut -d'=' -f 2)"
		[[ -n "${ISABELLE_HOME}" ]] || die "ISABELLE_HOME empty"
		dodir "${ISABELLE_HOME}/contrib/${PN}-${PV}/etc"
		cat <<- EOF >> "${S}/settings"
			SPASS_HOME="${ROOT}usr/bin"
			SPASS_VERSION="${PV}"
		EOF
		insinto "${ISABELLE_HOME}/contrib/${PN}-${PV}/etc"
		doins "${S}/settings"
	fi
}

pkg_postinst() {
	if use isabelle; then
		if [ -f "${ROOT}etc/isabelle/components" ]; then
			if egrep "contrib/${PN}-[0-9.]*" "${ROOT}etc/isabelle/components"; then
				sed -e "/contrib\/${PN}-[0-9.]*/d" \
					-i "${ROOT}etc/isabelle/components"
			fi
			cat <<- EOF >> "${ROOT}etc/isabelle/components"
				contrib/${PN}-${PV}
			EOF
		fi
	fi
}

pkg_postrm() {
	if use isabelle; then
		if [ ! -f "${ROOT}usr/bin/SPASS" ]; then
			if [ -f "${ROOT}etc/isabelle/components" ]; then
				# Note: this sed should only match the version of this ebuild
				# Which is what we want as we do not want to remove the line
				# of a new spass being installed during an upgrade.
				sed -e "/contrib\/${PN}-${PV}/d" \
					-i "${ROOT}etc/isabelle/components"
			fi
		fi
	fi
}
