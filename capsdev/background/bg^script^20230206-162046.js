// sn-scriptsync - Received from background script tab via SN Utils. (delete file after usage.)

//glide record a case
var gr = new GlideRecord('sn_customerservice_case');
gr.addQuery('number', 'CS0195868');
gr.query();
if (gr.next()) {
    gr.setValue("description", "This is a test 2");
    gr.update();
    gs.print("toto");
}
