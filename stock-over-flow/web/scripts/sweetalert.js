/*
var formName, confirmed = false;;
function confirmDeletion(name) {
    console.log('confirmDeletion');
    formName = name;
}

document.addEventListener("submit", (e) => {
        if(e.target.name === formName && !confirmed) {
            e.preventDefault();
            var thisApp = this;
            var event = e;
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire(
                        'Deleted!',
                        'Your file has been deleted.',
                        'success'
                        );
                confirmed = true;
                console.dir(thisApp.document.forms[formName]);
            }
        });
    }
});
 * 
 */