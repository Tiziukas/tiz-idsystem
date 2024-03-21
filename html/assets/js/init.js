$(document).ready(function(){
  window.addEventListener('message', function( event ) {
    if (event.data.action == 'open') {
      var type        = event.data.type;
      var userData    = event.data.array['user'][0];
      var licenseData = event.data.array['licenses'];
      var sex         = userData.sex;
      var mugshot = event.data.mugshot;
      var medicl = event.data.medicl;
      var weaponl = event.data.weaponl;

      if ( type == 'driver' || type == null) {
        $('img').show();
        $('#name').css('color', '#282828');

        if ( sex.toLowerCase() == 'm' ) {
          $('img').attr('src', mugshot);
          $('#sex').text('m');
        } else {
          $('img').attr('src', mugshot);
          $('#sex').text('f');
        }

        $('#name').text(userData.firstname + ' ' + userData.lastname);
        $('#dob').text(userData.dateofbirth);
        $('#height').text(userData.height);
        $('#signature').text(userData.firstname + ' ' + userData.lastname);

        if ( type == 'driver' ) {
          if ( licenseData != null ) {
          Object.keys(licenseData).forEach(function(key) {
            var type = licenseData[key].type;

            if ( type == 'drive_bike') {
              type = 'bike';
            } else if ( type == 'drive_truck' ) {
              type = 'truck';
            } else if ( type == 'drive' ) {
              type = 'car';
            }

            if ( type == 'bike' || type == 'truck' || type == 'car' ) {
              $('#licenses').append('<p>'+ type +'</p>');
            }
          });
        }

          $('#id-card').css('background', 'url(assets/images/license.png)');
        } else {
          $('#id-card').css('background', 'url(assets/images/idcard.png)');
        }
      } else if ( type == weaponl ) {
        $('img').hide();
        $('#name').css('color', '#d9d9d9');
        $('#name').text(userData.firstname + ' ' + userData.lastname);
        $('#dob').text(userData.dateofbirth);
        $('#signature').text(userData.firstname + ' ' + userData.lastname);

        $('#id-card').css('background', 'url(assets/images/firearm.png)');
        
      } else if ( type == medicl ) {
        $('img').hide();
        $('#name').css('color', '#d9d9d9');
        $('#name').text(userData.firstname + ' ' + userData.lastname);
        $('#dob').text(userData.dateofbirth);
        $('#signature').text(userData.firstname + ' ' + userData.lastname);

        $('#id-card').css('background', 'url(assets/images/medic.png)');
      } else if ( type == 'fakeid' || type == null) {
        $('img').show();
        $('#name').css('color', '#282828');

        $('img').attr('src', mugshot);
        $('#sex').text(userData.gender);
        }

        $('#name').text(userData.newname);
        $('#dob').text(userData.dob);
        $('#height').text(userData.height);
        $('#signature').text(userData.newname);
        $('#licenses').append('<p>'+ userData.category +'</p>');

        if ( type == 'fakeid' ) {
          if ( licenseData != null ) {
          Object.keys(licenseData).forEach(function(key) {
            var type = licenseData[key].type;
            if ( type == 'fakeid' ) {
              type = 'fakeid';
            }
          });
        }
      $('#id-card').css('background', 'url(assets/images/license.png)');
      }
      $('#id-card').show();
    } else if (event.data.action == 'close') {
      $('#name').text('');
      $('#dob').text('');
      $('#height').text('');
      $('#signature').text('');
      $('#sex').text('');
      $('#id-card').hide();
      $('#licenses').html('');
    } 
  });
});
