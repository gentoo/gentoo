# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

SAMPLE_COMMIT=200644f7219811c3930ad1732ef70c570ece2d16
DESCRIPTION="Python library to work with PDF files"
HOMEPAGE="
	https://pypi.org/project/PyPDF2/
	https://github.com/py-pdf/PyPDF2/
"
SRC_URI="
	https://github.com/py-pdf/PyPDF2/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://github.com/py-pdf/sample-files/archive/${SAMPLE_COMMIT}.tar.gz
			-> ${PN}-sample-files-${SAMPLE_COMMIT}.gh.tar.gz
	)
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.8 3.9)
"
BDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	test? (
		dev-python/pycryptodome[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Needs network access
	tests/test_cmap.py
	tests/test_filters.py::test_decompress_zlib_error
	tests/test_filters.py::test_lzw_decode_neg1
	tests/test_generic.py::test_dict_read_from_stream
	tests/test_generic.py::test_parse_content_stream_peek_percentage
	tests/test_generic.py::test_read_inline_image_no_has_q
	tests/test_generic.py::test_read_inline_image_loc_neg_1
	tests/test_generic.py::test_text_string_write_to_stream
	tests/test_generic.py::test_name_object_read_from_stream_unicode_error
	tests/test_generic.py::test_bool_repr
	tests/test_generic.py::test_issue_997
	tests/test_merger.py::test1
	tests/test_merger.py::test_bookmark
	tests/test_merger.py::test_iss1145
	tests/test_merger.py::test_sweep_indirect_list_newobj_is_None
	tests/test_merger.py::test_sweep_recursion1
	tests/test_merger.py::test_sweep_recursion2
	tests/test_merger.py::test_trim_outline
	tests/test_merger.py::test_trim_outline_list
	tests/test_merger.py::test_zoom
	tests/test_merger.py::test_zoom_xyz_no_left
	tests/test_page.py::test_extract_text_operator_t_star
	tests/test_page.py::test_extract_text_page_pdf
	tests/test_page.py::test_extract_text_page_pdf_impossible_decode_xform
	tests/test_page.py::test_extract_text_single_quote_op
	'tests/test_page.py::test_page_operations[https://arxiv.org/pdf/2201.00029.pdf-None]'
	tests/test_reader.py::test_extract_text_pdf15
	tests/test_reader.py::test_extract_text_xref_issue_2
	tests/test_reader.py::test_extract_text_xref_issue_3
	tests/test_reader.py::test_extract_text_xref_table_21_bytes_clrf
	tests/test_reader.py::test_get_fields
	tests/test_reader.py::test_get_fields_read_else_block
	tests/test_reader.py::test_get_fields_read_else_block2
	tests/test_reader.py::test_get_fields_read_else_block3
	tests/test_reader.py::test_get_fields_read_write_report
	tests/test_reader.py::test_iss925
	tests/test_reader.py::test_metadata_is_none
	tests/test_reader.py::test_outline_color
	tests/test_reader.py::test_outline_font_format
	tests/test_reader.py::test_outline_with_empty_action
	tests/test_reader.py::test_outline_with_missing_named_destination
	tests/test_reader.py::test_read_form_416
	tests/test_reader.py::test_unexpected_destination
	tests/test_reader.py::test_unexpected_destination
	tests/test_reader.py::test_xfa_non_empty
	tests/test_utils.py::test_deprecate_no_replacement
	tests/test_workflows.py::test_compress
	tests/test_workflows.py::test_extract_text
	tests/test_workflows.py::test_extract_textbench
	tests/test_workflows.py::test_get_fields
	tests/test_workflows.py::test_get_fonts
	tests/test_workflows.py::test_get_metadata
	tests/test_workflows.py::test_get_outline
	tests/test_workflows.py::test_image_extraction
	tests/test_workflows.py::test_merge
	tests/test_workflows.py::test_merge_with_warning
	tests/test_workflows.py::test_overlay
	tests/test_workflows.py::test_scale_rectangle_indirect_object
	tests/test_workflows.py::test_get_xfa
	tests/test_writer.py::test_sweep_indirect_references_nullobject_exception
	tests/test_writer.py::test_write_bookmark_on_page_fitv
	tests/test_xmp.py::test_custom_properties
	tests/test_xmp.py::test_dc_creator
	tests/test_xmp.py::test_dc_description
	tests/test_xmp.py::test_dc_subject
	tests/test_xmp.py::test_issue585
	tests/test_xmp.py::test_xmpmm

	# Broken test
	tests/test_utils.py::test_deprecate_no_replacement
)

src_unpack() {
	default
	if use test; then
		mv "sample-files-${SAMPLE_COMMIT}"/* "${P}"/sample-files/ || die
	fi
}
